# Edge Functions

Se despliegan **a mano** (igual que las migraciones SQL) — el GitHub Actions
de este repo solo compila el build web de Flutter y lo sube a Vercel, no
toca Supabase.

Desplegar una función:

```
supabase functions deploy admin-usuarios --project-ref tbnvnuvqzhtgfthuuidi
```

(o desde el MCP de Supabase en una sesión de Claude Code, o desde el
Dashboard → Edge Functions).

Las variables `SUPABASE_URL`, `SUPABASE_ANON_KEY` y
`SUPABASE_SERVICE_ROLE_KEY` las inyecta el runtime de Edge Functions
automáticamente — no hay que configurarlas como secretos.

## `admin-usuarios`

Gestión de cuentas administradoras de CDMB. Ver 0039 y el encabezado de
`admin-usuarios/index.ts`. Solo la puede llamar un súper administrador
(`perfiles.es_super_admin = true`, `activo = true`); `verify_jwt` está
activo, así que además la plataforma exige un JWT válido antes de ejecutar
el código. La usa `lib/services/usuarios_service.dart`.
