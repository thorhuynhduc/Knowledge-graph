# Deploy Knowledge Graph 3D lên VPS Hostinger — domain hvnk.tech

Hướng dẫn đưa app lên **VPS Hostinger (KVM, Ubuntu 22.04)** chạy tại **https://hvnk.tech** với HTTPS tự động.
Stack: **MySQL + Node app + Caddy** (reverse proxy + SSL Let's Encrypt), tất cả bằng Docker.

> **2 phương án — chọn 1:**
> - **(A) Caddy trong Docker** — auto-SSL, ít bước nhất → **tài liệu này**.
> - **(B) Nginx host + Certbot Docker** — theo convention Course-online, code ở `/var/www/knowledge` → xem **[`deploy/README.md`](deploy/README.md)**.

> App đã có **đăng nhập tích hợp** (username/password trong `.env`) + **chống brute-force**.
> Không cần khóa thêm bằng Caddy basicauth nữa (xem mục 8).

---

## 0. Chuẩn bị

- 1 VPS Hostinger (**KVM**, hệ điều hành **Ubuntu 22.04**).
- Domain **hvnk.tech** (quản lý được DNS — Hostinger hoặc nơi đăng ký domain).
- Biết **IP public của VPS** (hPanel → VPS → Overview).

---

## 1. Trỏ domain về VPS (DNS)

Vào nơi quản lý DNS của `hvnk.tech` (Hostinger hPanel → **Domains → DNS Zone**), tạo 2 bản ghi **A**:

| Type | Name | Points to (Value) | TTL |
|------|------|-------------------|-----|
| A    | `@`  | `<IP_VPS>`        | 3600 |
| A    | `www`| `<IP_VPS>`        | 3600 |

> Xoá bản ghi A/AAAA cũ trỏ sai nếu có. DNS có thể mất 5–30 phút (đôi khi vài giờ) để cập nhật.
> Kiểm tra: `ping hvnk.tech` phải ra đúng IP VPS, hoặc dùng https://dnschecker.org.

---

## 2. SSH vào VPS & cập nhật

```bash
ssh root@<IP_VPS>
apt update && apt -y upgrade
```

---

## 3. Cài Docker + Docker Compose

```bash
curl -fsSL https://get.docker.com | sh
docker --version
docker compose version
```

(Docker Compose v2 đã đi kèm Docker mới.)

---

## 4. Mở firewall cho web

Nếu VPS bật **UFW**:
```bash
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

> Kiểm tra thêm **Firewall trong hPanel Hostinger** (VPS → Firewall): cho phép cổng **80** và **443** (TCP). Nếu chặn sẽ không xin được SSL.

---

## 5. Đưa code lên VPS

**Cách A — Git (khuyến nghị):**
```bash
cd /opt
git clone <URL_REPO_CUA_BAN> knowledge-graph
cd knowledge-graph              # thư mục chứa docker-compose.prod.yml
```

**Cách B — Upload bằng scp** (chạy ở MÁY CỦA BẠN, không phải trên VPS):
```bash
scp -r /home/tho/Projects/Knowledge-graph root@<IP_VPS>:/opt/knowledge-graph
# rồi trên VPS:
cd /opt/knowledge-graph
```

> Lưu ý: `.env` **không** nằm trong git (đã gitignore). Bản prod bạn tự tạo ở bước 6.

---

## 6. Tạo file .env (bắt buộc — chứa mật khẩu đăng nhập + bảo mật)

Trong thư mục chứa `docker-compose.prod.yml`:
```bash
cp .env.example .env
openssl rand -hex 32           # copy chuỗi này để dán vào SESSION_SECRET
nano .env
```

Điền (đổi mọi mật khẩu cho mạnh):
```env
# --- Database ---
DB_NAME=knowledge_graph
DB_USER=kguser
DB_PASS=DOI_MAT_KHAU_DB_MANH
MYSQL_ROOT_PASSWORD=DOI_ROOT_PASS_MANH

# --- Đăng nhập app (bắt buộc) ---
AUTH_USER=admin
AUTH_PASS=DOI_MAT_KHAU_DANG_NHAP_MANH
SESSION_SECRET=<DÁN_CHUỖI_openssl_rand_hex_32_VÀO_ĐÂY>
SESSION_TTL_HOURS=168
COOKIE_SECURE=true             # BẮT BUỘC true ở prod (chạy sau HTTPS của Caddy)

# Token khóa thao tác ghi ở tầng API (tùy chọn, thường để trống vì đã có login)
API_TOKEN=
```
Lưu: `Ctrl+O`, `Enter`, thoát `Ctrl+X`.

> `docker-compose.prod.yml` **bắt buộc** có `AUTH_USER`, `AUTH_PASS`, `SESSION_SECRET`, `MYSQL_ROOT_PASSWORD`, `DB_PASS` — thiếu sẽ báo lỗi khi `up`.
> `SESSION_SECRET` cố định giúp **không bị đăng xuất** mỗi lần restart. `COOKIE_SECURE=true` để cookie chỉ gửi qua HTTPS và lấy đúng IP client (trust proxy) cho chống brute-force.

---

## 7. Khởi chạy

```bash
docker compose -f docker-compose.prod.yml up -d --build
```

Lần đầu MySQL tự tạo bảng + nạp **~93 node + 121 quan hệ** từ `seed.sql`. Caddy tự xin SSL cho hvnk.tech.

Theo dõi log (đợi Caddy lấy chứng chỉ xong) và trạng thái:
```bash
docker compose -f docker-compose.prod.yml logs -f caddy
docker compose -f docker-compose.prod.yml ps      # app phải ở trạng thái (healthy)
```

> App có healthcheck (`GET /healthz`); cột STATUS hiện `(healthy)` là OK.

→ Mở trình duyệt: **https://hvnk.tech** → trang **đăng nhập** → nhập `AUTH_USER` / `AUTH_PASS` đã đặt 🎉

---

## 8. Bảo mật

App đã **bắt buộc đăng nhập** mới vào được (cơ chế cookie phiên ký HMAC, không thư viện ngoài) và **khóa tạm IP sau 5 lần sai/10 phút**. Vì vậy:

- **Việc cần làm:** đặt `AUTH_USER` / `AUTH_PASS` mạnh và `SESSION_SECRET` cố định trong `.env` (mục 6). Đó chính là lớp khóa truy cập.
- `COOKIE_SECURE=true` ở prod để cookie an toàn qua HTTPS.
- **Không cần** Caddy basicauth nữa — nó sẽ bắt đăng nhập 2 lần. Khối `basicauth` trong `Caddyfile` để mặc định **comment**; chỉ bật nếu muốn thêm 1 lớp mật khẩu ở tầng proxy.

Đổi mật khẩu sau này:
```bash
nano .env        # sửa AUTH_PASS
docker compose -f docker-compose.prod.yml up -d        # nạp lại env cho app
```

> (Tùy chọn) Khóa thêm thao tác ghi ở tầng API: đặt `API_TOKEN=chuoi_bi_mat` trong `.env` **và** sửa `const API_TOKEN` trong `public/index.html` cho khớp, rồi `restart app`.

---

## 9. Cập nhật / vận hành

**Cập nhật code mới:**
```bash
cd /opt/knowledge-graph
git pull                                              # nếu dùng git
docker compose -f docker-compose.prod.yml up -d --build
```
> Sửa `public/index.html` (frontend) thì chỉ cần **F5** — đã mount, không phải rebuild.

**Nạp lại data mẫu (XOÁ sạch data hiện tại):**
```bash
docker compose -f docker-compose.prod.yml down -v
docker compose -f docker-compose.prod.yml up -d --build
```

**Sao lưu DB:**
```bash
docker compose -f docker-compose.prod.yml exec mysql \
  sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" knowledge_graph' > backup_$(date +%F).sql
```

**Khôi phục DB từ file backup:**
```bash
docker compose -f docker-compose.prod.yml exec -T mysql \
  sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" knowledge_graph' < backup_2026-06-29.sql
```

**Lệnh hữu ích:**
```bash
docker compose -f docker-compose.prod.yml logs -f app     # log app
docker compose -f docker-compose.prod.yml restart app     # restart app
docker compose -f docker-compose.prod.yml down            # dừng (giữ data)
```

---

## 10. Khắc phục sự cố

| Triệu chứng | Cách xử lý |
|-------------|-----------|
| Không vào được https, lỗi SSL | Kiểm tra DNS đã trỏ đúng IP (`ping hvnk.tech`); cổng 80/443 đã mở (UFW + firewall hPanel). Xem `logs -f caddy`. |
| Caddy báo "challenge failed" | DNS chưa kịp cập nhật hoặc cổng 80 bị chặn. Đợi DNS rồi `restart caddy`. |
| `up` báo thiếu biến (`AUTH_USER... bắt buộc`) | Chưa điền `.env`. Kiểm tra lại mục 6 (AUTH_USER/AUTH_PASS/SESSION_SECRET/DB_PASS/MYSQL_ROOT_PASSWORD). |
| Đăng nhập sai dù đúng mật khẩu | Có thể đang bị khóa brute-force (5 lần sai → chờ 5 phút). Hoặc `.env` chưa được nạp: chạy lại `up -d`. |
| Bị đăng xuất sau mỗi lần restart | `SESSION_SECRET` để trống → đặt chuỗi cố định trong `.env` rồi `up -d`. |
| App STATUS không `(healthy)` | `logs -f app`; thường do chưa nối được MySQL — kiểm tra `.env`, `down` rồi `up` lại. |
| Trang trắng/đen, đồ thị không hiện | Mở Console (F12). Nếu báo WebGL → máy/trình duyệt chưa bật tăng tốc đồ họa (app sẽ hiện thông báo hướng dẫn). Nếu chặn CDN `esm.sh` → báo lại để chuyển sang self-host thư viện. |
| Đổi domain khác | Sửa tên miền trong `Caddyfile` rồi `restart caddy`. |

---

### Tóm tắt nhanh (sau khi DNS đã trỏ)
```bash
ssh root@<IP_VPS>
curl -fsSL https://get.docker.com | sh
cd /opt && git clone <REPO> knowledge-graph && cd knowledge-graph
cp .env.example .env
openssl rand -hex 32                         # dán vào SESSION_SECRET
nano .env                                    # đặt AUTH_USER/AUTH_PASS, DB_PASS, MYSQL_ROOT_PASSWORD, COOKIE_SECURE=true
ufw allow OpenSSH && ufw allow 80/tcp && ufw allow 443/tcp && ufw --force enable
docker compose -f docker-compose.prod.yml up -d --build
# -> https://hvnk.tech  (đăng nhập bằng AUTH_USER / AUTH_PASS)
```
