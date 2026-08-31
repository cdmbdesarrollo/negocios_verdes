// admin-usuarios — gestión de cuentas administradoras de CDMB.
//
// La creación de un usuario de Auth necesita la service_role key, que NUNCA
// puede viajar al cliente Flutter (la protección real del proyecto son las
// políticas RLS + esta función). Por eso vive acá y no en una RPC de
// Postgres: la migración 0002/0010 ya deja dicho que un INSERT crudo en
// auth.users "no es seguro ni soportado".
//
// Sólo un SÚPER ADMIN (`perfiles.es_super_admin = true` y `activo = true`)
// puede llamar cualquier acción. Se verifica con el JWT de quien llama
// (verify_jwt de la plataforma ya garantiza que hay un JWT válido; acá
// además se comprueba el rol contra `perfiles`).
//
// Acciones (POST JSON):
//   { "accion": "crear",      "email", "password", "nombre"?, "es_super_admin"? }
//   { "accion": "set_estado", "id", "activo": bool }
//   { "accion": "set_super",  "id", "es_super_admin": bool }
//
// Deploy: vía el MCP de Supabase o `supabase functions deploy admin-usuarios`
// (NO se despliega desde el GitHub Actions de Vercel — ese sólo compila y
// sube el build web). SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY
// las inyecta el runtime de Edge Functions, no hay que configurarlas.

import { createClient } from "npm:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "Método no permitido." }, 405);

  // --- quién llama ---------------------------------------------------------
  const authHeader = req.headers.get("Authorization") ?? "";
  const comoUsuario = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: userData, error: userErr } = await comoUsuario.auth.getUser();
  if (userErr || !userData?.user) {
    return json({ error: "Sesión no válida." }, 401);
  }
  const llamante = userData.user;

  const admin = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // --- ¿es súper admin? ---------------------------------------------------
  const { data: perfilLlamante } = await admin
    .from("perfiles")
    .select("es_super_admin, activo")
    .eq("id", llamante.id)
    .maybeSingle();
  if (!perfilLlamante?.es_super_admin || !perfilLlamante?.activo) {
    return json({ error: "Sólo un súper administrador puede gestionar cuentas." }, 403);
  }

  // --- cuerpo -------------------------------------------------------------
  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    return json({ error: "Cuerpo JSON inválido." }, 400);
  }
  const accion = String(body.accion ?? "");

  const registrar = (accionLog: string, entidadId: string | null, detalle: unknown) =>
    admin.from("admin_logs").insert({
      admin_id: llamante.id,
      accion: accionLog,
      entidad: "perfiles",
      entidad_id: entidadId,
      detalle,
    });

  try {
    // === crear ===========================================================
    if (accion === "crear") {
      const email = String(body.email ?? "").trim().toLowerCase();
      const password = String(body.password ?? "");
      const nombre = body.nombre ? String(body.nombre).trim() : null;
      const esSuper = body.es_super_admin === true;

      if (!email || !email.includes("@")) {
        return json({ error: "Escribe un correo válido." }, 400);
      }
      if (password.length < 8) {
        return json({ error: "La contraseña debe tener al menos 8 caracteres." }, 400);
      }

      const { data: creado, error: crearErr } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true, // no hay SMTP configurado — se crea ya confirmado
        user_metadata: nombre ? { nombre } : {},
      });
      if (crearErr || !creado?.user) {
        const msg = (crearErr?.message ?? "").toLowerCase();
        if (msg.includes("already") || msg.includes("registered") || msg.includes("exists")) {
          return json({ error: "Ya existe una cuenta con ese correo." }, 400);
        }
        return json({ error: crearErr?.message ?? "No se pudo crear la cuenta." }, 400);
      }

      // El trigger on_auth_user_created ya insertó la fila en perfiles;
      // upsert por si acaso, y para fijar rol/nombre/activo de una vez.
      const { error: perfilErr } = await admin.from("perfiles").upsert({
        id: creado.user.id,
        email,
        nombre,
        is_admin: true,
        es_super_admin: esSuper,
        activo: true,
      });
      if (perfilErr) {
        // rollback best-effort: si no se pudo dejar el perfil, borrar el auth user
        await admin.auth.admin.deleteUser(creado.user.id).catch(() => {});
        return json({ error: "La cuenta se creó a medias, intenta de nuevo." }, 500);
      }

      await registrar("crear_usuario", creado.user.id, { email, es_super_admin: esSuper });
      return json({ ok: true, id: creado.user.id, email });
    }

    // === set_estado (activar / desactivar) ===============================
    if (accion === "set_estado") {
      const id = String(body.id ?? "");
      const activo = body.activo === true;
      if (!id) return json({ error: "Falta el id del usuario." }, 400);
      if (id === llamante.id) {
        return json({ error: "No puedes desactivar tu propia cuenta." }, 400);
      }

      const { error: updErr } = await admin
        .from("perfiles")
        .update({ activo })
        .eq("id", id);
      if (updErr) return json({ error: updErr.message }, 400);

      // Matar / restaurar la sesión en Auth también (no sólo el flag).
      await admin.auth.admin.updateUserById(id, {
        ban_duration: activo ? "none" : "87600h",
      }).catch(() => {});

      await registrar(activo ? "activar_usuario" : "desactivar_usuario", id, { activo });
      return json({ ok: true });
    }

    // === set_super (promover / degradar) ================================
    if (accion === "set_super") {
      const id = String(body.id ?? "");
      const esSuper = body.es_super_admin === true;
      if (!id) return json({ error: "Falta el id del usuario." }, 400);
      if (id === llamante.id) {
        return json({ error: "No puedes cambiar tu propio nivel de súper administrador." }, 400);
      }

      if (!esSuper) {
        const { count } = await admin
          .from("perfiles")
          .select("id", { count: "exact", head: true })
          .eq("es_super_admin", true)
          .eq("activo", true);
        if ((count ?? 0) <= 1) {
          return json({ error: "Debe quedar al menos un súper administrador activo." }, 400);
        }
      }

      const { error: updErr } = await admin
        .from("perfiles")
        .update({ es_super_admin: esSuper })
        .eq("id", id);
      if (updErr) return json({ error: updErr.message }, 400);

      await registrar(esSuper ? "promover_super_admin" : "degradar_super_admin", id, {
        es_super_admin: esSuper,
      });
      return json({ ok: true });
    }

    return json({ error: `Acción desconocida: ${accion}` }, 400);
  } catch (e) {
    return json({ error: `Error inesperado: ${e instanceof Error ? e.message : e}` }, 500);
  }
});
