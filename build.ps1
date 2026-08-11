# build.ps1 - build de produccion y deploy a Vercel (git-connected, igual
# que HuellaQR: Vercel no compila, solo sirve build/web ya compilado).
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

Write-Host "Compilando Flutter Web (release, WebAssembly)..." -ForegroundColor Cyan
# --wasm: pipeline de renderizado distinto al CanvasKit-JS de siempre.
# Probado como posible causa de la pantalla en blanco al cerrar el dialogo
# de confirmacion de borrado. Si no lo resuelve, se puede quitar el flag.
flutter build web --release --wasm --dart-define=SUPABASE_URL=$env:SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY

if ($LASTEXITCODE -ne 0) {
  Write-Error "flutter build web fallo - revisa el error de arriba."
  exit 1
}

Write-Host "Publicando en git (Vercel despliega automaticamente al hacer push)..." -ForegroundColor Cyan
git add .
git add -f build/web
git commit -m "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push

Write-Host "Listo. Revisa el progreso del deploy en el dashboard de Vercel." -ForegroundColor Green
