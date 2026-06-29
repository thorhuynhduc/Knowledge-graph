# Deploy — Nginx (host) + Certbot (Docker) — /var/www/knowledge

Theo đúng convention dự án Course-online: **Nginx chạy trên host**, **Certbot chạy bằng Docker** (chỉ để cấp/gia hạn cert), app + MySQL chạy Docker và bind `127.0.0.1:3000` cho Nginx proxy vào.

> Phương án thay thế dùng **Caddy** (auto-SSL, mọi thứ trong Docker): xem `../DEPLOY.md`.

## Cấu trúc
```
deploy/
  certbot/
    docker-compose.yml   # service certbot (mount /etc/letsencrypt, /var/www/certbot)
    init-cert.sh         # cấp SSL lần đầu (webroot)
    renew.sh             # gia hạn SSL (chạy bởi cron) + reload nginx
  nginx/
    init-http.conf       # config TẠM (HTTP-only) cho lần cấp cert đầu
    hvnk.tech.conf       # config SSL thật (80->443, proxy 127.0.0.1:3000)
  scripts/
    deploy.sh            # pull + build + up + healthcheck
```
App chạy bằng `../docker-compose.nginx.yml` (app bind `127.0.0.1:3000`).

---

## Cài đặt lần đầu (VPS Ubuntu 22.04, đã có Docker)

**0. DNS:** trỏ `hvnk.tech` + `www.hvnk.tech` (A record) về IP VPS. Mở cổng 80, 443.

**1. Cài Nginx trên host:**
```bash
sudo apt update && sudo apt install -y nginx
```

**2. Lấy code về `/var/www/knowledge`:**
```bash
sudo mkdir -p /var/www/knowledge && sudo chown "$USER" /var/www/knowledge
git clone <URL_REPO_CUA_BAN> /var/www/knowledge
cd /var/www/knowledge
```

**3. Tạo `.env`** (bắt buộc — `AUTH_USER/AUTH_PASS/SESSION_SECRET/DB_PASS/MYSQL_ROOT_PASSWORD`, `COOKIE_SECURE=true`):
```bash
cp .env.example .env
openssl rand -hex 32      # dán vào SESSION_SECRET
nano .env
```

**4. Chạy app (Docker):**
```bash
bash deploy/scripts/deploy.sh
```

**5. Cài Nginx HTTP-only rồi cấp SSL:**
```bash
# config tạm để Certbot xác thực
sudo cp deploy/nginx/init-http.conf /etc/nginx/sites-available/init-http.conf
sudo ln -sf /etc/nginx/sites-available/init-http.conf /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx

# cấp SSL (Certbot bằng Docker)
sudo bash deploy/certbot/init-cert.sh
```

**6. Bật SSL config thật:**
```bash
sudo rm /etc/nginx/sites-enabled/init-http.conf
sudo cp deploy/nginx/hvnk.tech.conf /etc/nginx/sites-available/hvnk.tech.conf
sudo ln -sf /etc/nginx/sites-available/hvnk.tech.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

**7. Cron gia hạn SSL (2 tháng/lần):**
```bash
sudo crontab -e
# thêm dòng:
0 3 1 */2 * /var/www/knowledge/deploy/certbot/renew.sh >> /var/log/certbot-renew.log 2>&1
```

→ Mở **https://hvnk.tech** → đăng nhập bằng `AUTH_USER` / `AUTH_PASS`. 🎉

---

## Cập nhật về sau
```bash
cd /var/www/knowledge
bash deploy/scripts/deploy.sh        # pull + build + restart app
```
> Sửa `public/index.html` (frontend) chỉ cần **F5** — đã mount, không rebuild.
> Đổi Nginx config thì `cp` lại vào sites-available rồi `sudo nginx -t && sudo systemctl reload nginx`.

## Vận hành
```bash
DC="docker compose -f docker-compose.nginx.yml"
$DC ps                 # app phải 'healthy'
$DC logs -f app        # log app
$DC down               # dừng (giữ data)
$DC down -v            # dừng + XOÁ data (lần sau nạp lại seed)

sudo tail -f /var/log/nginx/error.log          # log nginx host
bash deploy/certbot/renew.sh                    # thử gia hạn SSL thủ công
```

**Sao lưu / khôi phục DB:**
```bash
DC="docker compose -f docker-compose.nginx.yml"
$DC exec mysql sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" knowledge_graph' > backup_$(date +%F).sql
$DC exec -T mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" knowledge_graph' < backup_2026-06-29.sql
```

## Khắc phục sự cố
| Triệu chứng | Cách xử lý |
|-------------|-----------|
| `init-cert.sh` lỗi cấp cert | DNS chưa trỏ đúng IP, hoặc cổng 80 bị chặn, hoặc chưa bật `init-http.conf`. Xem `/var/log/letsencrypt`. |
| 502 Bad Gateway | App chưa healthy. `docker compose -f docker-compose.nginx.yml ps` + `logs -f app`. |
| `nginx -t` báo thiếu cert | Chưa chạy `init-cert.sh`. Quay lại bước 5. |
| Bị đăng xuất sau restart | `SESSION_SECRET` trống → đặt cố định trong `.env` rồi `deploy.sh`. |
| SSL không tự gia hạn | Kiểm tra cron (`sudo crontab -l`) và log `/var/log/certbot-renew.log`. |
