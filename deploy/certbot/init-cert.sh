#!/bin/bash
# Cấp SSL lần đầu — chạy 1 lần duy nhất khi setup server.
# Điều kiện: Nginx host đang chạy với HTTP-only config (deploy/nginx/init-http.conf).

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[certbot] Tạo webroot directory..."
mkdir -p /var/www/certbot

echo "[certbot] Cấp SSL cho hvnk.tech + www..."
docker compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  -d hvnk.tech \
  -d www.hvnk.tech \
  --email thohuynhduc24@gmail.com \
  --agree-tos \
  --no-eff-email \
  --non-interactive

echo "[certbot] SSL đã cấp thành công!"
echo ""
echo "Bước tiếp theo:"
echo "  1. Gỡ HTTP-only config:"
echo "       rm /etc/nginx/sites-enabled/init-http.conf"
echo "  2. Cài SSL config thật:"
echo "       cp deploy/nginx/hvnk.tech.conf /etc/nginx/sites-available/hvnk.tech.conf"
echo "       ln -sf /etc/nginx/sites-available/hvnk.tech.conf /etc/nginx/sites-enabled/"
echo "  3. Test & reload nginx:"
echo "       nginx -t && systemctl reload nginx"
