/// Credenciales de Supabase. Nunca hardcodeadas: se leen al compilar/correr
/// vía --dart-define (ver build.ps1 y .claude/launch.json). El anon key es
/// seguro de traer al cliente (Supabase lo diseñó para eso) — la protección
/// real de los datos está en las políticas RLS de cada tabla, no en mantener
/// esta llave en secreto.
library;

const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: '',
);

const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: '',
);

/// Falla ruidosamente en vez de dejar la app arrancar a medias sin backend.
void validarConfiguracion() {
  if (supabaseUrl.isEmpty) {
    throw StateError(
      'SUPABASE_URL no está definida. Corre con '
      '--dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co',
    );
  }
  if (supabaseAnonKey.isEmpty) {
    throw StateError(
      'SUPABASE_ANON_KEY no está definida. Corre con '
      '--dart-define=SUPABASE_ANON_KEY=tu-anon-key',
    );
  }
}
