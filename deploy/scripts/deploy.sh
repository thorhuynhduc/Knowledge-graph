#!/bin/bash
# Deploy / cập nhật Knowledge Graph 3D trên server.
# Chạy: bash /var/www/knowledge/deploy/scripts/deploy.sh

set -e

REPO_DIR="${REPO_DIR:-/var/www/knowledge}"
COMPOSE_FILE="docker-compose.nginx.yml"
DC="docker compose -f $COMPOSE_FILE"

cd "$REPO_DIR"

[ -f .env ] || { echo "[deploy] Thiếu .env — cp .env.example .env và điền mật khẩu trước."; exit 1; }

echo "[deploy] Pull code mới nhất..."
[ -d .git ] && git pull origin main || echo "[deploy] (không phải git repo — bỏ qua)"

echo "[deploy] Build & khởi động containers..."
$DC up -d --build

echo "[deploy] Đợi app healthy..."
CID="$($DC ps -q app)"
for _ in $(seq 1 30); do
  h="$(docker inspect -f '{{.State.Health.Status}}' "$CID" 2>/dev/null || echo '')"
  [ "$h" = "healthy" ] && break
  sleep 2
done
$DC ps

echo "[deploy] Kiểm tra healthz..."
curl -fsS "http://127.0.0.1:${APP_PORT:-3000}/healthz" && echo

echo "[deploy] Xong! -> https://hvnk.tech"
