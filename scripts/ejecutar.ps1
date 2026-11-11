# Levanta Hive 4 y corre los scripts HiveQL de este repositorio (Beeline).
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

docker compose up -d

Write-Host "Esperando a HiveServer2 (puerto 10000)..."
$ok = $false
for ($i = 1; $i -le 40; $i++) {
    docker compose exec -T hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" -e "SELECT 1" 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $ok = $true; break }
    Start-Sleep -Seconds 3
}
if (-not $ok) { throw "HiveServer2 no respondio a tiempo. Revisar: docker compose logs hiveserver2" }

$files = @(
    "01_ddl.sql",
    "02_dml.sql",
    "03_p02_calidad.sql",
    "04_p03_evolucion_region.sql",
    "05_p04_rfm.sql",
    "06_p05_ranking_productos.sql",
    "07_p06_descuentos.sql",
    "08_p07_tendencias.sql",
    "09_p08_pareto.sql",
    "10_optimizacion.sql"
)

foreach ($f in $files) {
    Write-Host "===== $f ====="
    docker compose exec -T hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f "/opt/sql/$f"
    if ($LASTEXITCODE -ne 0) { throw "Fallo $f" }
}

Write-Host "Listo. UI de HiveServer2: http://localhost:10002/"
