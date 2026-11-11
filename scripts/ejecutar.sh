#!/usr/bin/env bash
# Levanta Hive 4 y corre los scripts HiveQL de este repositorio (Beeline).
set -euo pipefail
cd "$(dirname "$0")/.."

docker compose up -d

echo "Esperando a HiveServer2 (puerto 10000)..."
ok=0
for i in $(seq 1 40); do
  if docker compose exec -T hiveserver2 beeline -u 'jdbc:hive2://localhost:10000/' -e 'SELECT 1' >/dev/null 2>&1; then
    ok=1
    break
  fi
  sleep 3
done
if [ "$ok" -ne 1 ]; then
  echo "HiveServer2 no respondio a tiempo. Revisar: docker compose logs hiveserver2" >&2
  exit 1
fi

for f in \
  01_ddl.sql \
  02_dml.sql \
  03_p02_calidad.sql \
  04_p03_evolucion_region.sql \
  05_p04_rfm.sql \
  06_p05_ranking_productos.sql \
  07_p06_descuentos.sql \
  08_p07_tendencias.sql \
  09_p08_pareto.sql \
  10_optimizacion.sql
do
  echo "===== $f ====="
  docker compose exec -T hiveserver2 beeline -u 'jdbc:hive2://localhost:10000/' --showHeader=true -f "/opt/sql/${f}"
done

echo "Listo. UI de HiveServer2: http://localhost:10002/"
