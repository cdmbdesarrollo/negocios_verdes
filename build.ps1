# build.ps1 - build de produccion LOCAL, solo para probar antes de un push.
#
# El deploy real ya no lo hace este script: desde que existe
# .github/workflows/deploy.yml, cada push a master dispara un build +
# "vercel deploy --prod" propios en GitHub Actions (ver ese archivo). Este
# script quedo desactualizado un tiempo despues de esa migracion - todavia
# comiteaba build/web a git y hacia push, redundante con el workflow y
# encima forzaba (git add -f) un directorio que .gitignore excluye a
# proposito. Ahora solo compila local para que puedas revisar el build de
# produccion con tus propios ojos antes de confiar en que el CI lo haga
# bien - no toca git para nada.
#
# Requiere un archivo local "env.local.ps1" (NO se sube a git - ver
# .gitignore) con:
#   $env:SUPABASE_URL = "https://tu-proyecto.supabase.co"
#   $env:SUPABASE_ANON_KEY = "tu-anon-key"
#
# El anon key es seguro de traer al build (Supabase lo diseno para ser
# publico, la proteccion real son las politicas RLS) - igual se mantiene
# fuera de git por prolijidad, no por secreto.

$ErrorActionPreference = "Stop"

if (-not (Test-Path "env.local.ps1")) {
  Write-Error "Falta env.local.ps1 en la raiz del proyecto - crea el archivo con SUPABASE_URL y SUPABASE_ANON_KEY (ver comentario arriba de este script)."
  exit 1
}
. .\env.local.ps1

if (-not $env:SUPABASE_URL -or -not $env:SUPABASE_ANON_KEY) {
  Write-Error "SUPABASE_URL o SUPABASE_ANON_KEY no quedaron definidas despues de cargar env.local.ps1."
  exit 1
}

Write-Host "Compilando Flutter Web (release)..." -ForegroundColor Cyan
flutter build web --release --dart-define=SUPABASE_URL=$env:SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY

if ($LASTEXITCODE -ne 0) {
  Write-Error "flutter build web fallo - revisa el error de arriba."
  exit 1
}

Write-Host "Build listo en build/web. Para probarlo local: 'python -m http.server 8080 --directory build/web' (o cualquier servidor estatico)." -ForegroundColor Green
Write-Host "El deploy real pasa solo con 'git push' a master - GitHub Actions se encarga del resto." -ForegroundColor Green
