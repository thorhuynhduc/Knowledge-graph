#!/bin/bash
# Gia hạn SSL — chạy bởi cron, Nginx host phải đang chạy.
# Cron (gia hạn 2 tháng/lần lúc 3h sáng ngày 1):
#   0 3 1 */2 * /var/www/knowledge/deploy/certbot/renew.sh >> /var/log/certbot-renew.log 2>&1

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Bắt đầu renew SSL..."

docker compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm certbot renew \
  --webroot \
  --webroot-path /var/www/certbot \
  --quiet

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Renew xong. Reload Nginx..."
systemctl reload nginx

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Hoàn thành."
