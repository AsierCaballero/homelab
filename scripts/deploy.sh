#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Deploying HomeLab Services ==="

cp -n "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env" 2>/dev/null || true

echo "[1/4] Validating configurations..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" config > /dev/null
echo "  ✓ Core compose valid"

if [ -f "$PROJECT_DIR/docker-compose.monitoring.yml" ]; then
    docker compose -f "$PROJECT_DIR/docker-compose.monitoring.yml" config > /dev/null
    echo "  ✓ Monitoring compose valid"
fi

echo "[2/4] Creating required directories..."
mkdir -p "$PROJECT_DIR/data/portainer" \
         "$PROJECT_DIR/data/grafana" \
         "$PROJECT_DIR/data/prometheus" \
         "$PROJECT_DIR/data/adguard" \
         "$PROJECT_DIR/data/uptime-kuma" \
         "$PROJECT_DIR/backups"

echo "[3/4] Pulling latest images..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" pull --quiet
echo "  ✓ Core images pulled"

if [ -f "$PROJECT_DIR/docker-compose.monitoring.yml" ]; then
    docker compose -f "$PROJECT_DIR/docker-compose.monitoring.yml" pull --quiet
    echo "  ✓ Monitoring images pulled"
fi

echo "[4/4] Starting services..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d
echo "  ✓ Core services started"

if [ -f "$PROJECT_DIR/docker-compose.monitoring.yml" ]; then
    docker compose -f "$PROJECT_DIR/docker-compose.monitoring.yml" up -d
    echo "  ✓ Monitoring stack started"
fi

echo "=== Deployment Complete ==="
echo "Run './scripts/health-check.sh' to verify all services."
