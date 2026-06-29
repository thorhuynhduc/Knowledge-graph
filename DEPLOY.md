# Deploy Knowledge Graph 3D lên VPS Hostinger — domain hvnk.tech

Hướng dẫn đưa app lên **VPS Hostinger** chạy tại **https://hvnk.tech** với HTTPS tự động.
Stack: **MySQL + Node app + Caddy** (reverse proxy + SSL Let's Encrypt), tất cả bằng Docker.

---

## 0. Chuẩn bị

- 1 VPS Hostinger (KVM, hệ điều hành **Ubuntu 22.04/24.04**).
- Domain **hvnk.tech** (quản lý DNS được — Hostinger hoặc nơi đăng ký domain).
- Biết **IP public của VPS** (xem trong hPanel → VPS → Overview).

---

## 1. Trỏ domain về VPS (DNS)

Vào nơi quản lý DNS của `hvnk.tech` (Hostinger hPanel → **Domains → DNS / Nameservers → DNS Zone**), tạo 2 bản ghi **A**:

| Type | Name | Points to (Value) | TTL |
|------|------|-------------------|-----|
| A    | `@`  | `<IP_VPS>`        | 3600 |
| A    | `www`| `<IP_VPS>`        | 3600 |

> Xoá bản ghi A/AAAA cũ trỏ sai nếu có. DNS có thể mất 5–30 phút (đôi khi tới vài giờ) để cập nhật.
> Kiểm tra: `ping hvnk.tech` phải ra đúng IP VPS, hoặc dùng https://dnschecker.org.

---

## 2. SSH vào VPS

```bash
ssh root@<IP_VPS>
```

Cập nhật hệ thống:
```bash
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

> Ngoài ra kiểm tra **Firewall trong hPanel Hostinger** (VPS → Firewall): đảm bảo cho phép cổng **80** và **443** (TCP). Nếu không sẽ không xin được SSL.

---

## 5. Đưa code lên VPS

**Cách A — Git (khuyến nghị):**
```bash
cd /opt
git clone <URL_REPO_CUA_BAN> knowledge-graph
cd knowledge-graph/kg_node      # vào đúng thư mục chứa docker-compose.prod.yml
```

**Cách B — Upload thủ công bằng scp** (chạy ở máy của bạn, không phải trên VPS):
```bash
scp -r /Users/anhuynh/Documents/Project_Thor/kg_node root@<IP_VPS>:/opt/knowledge-graph
# rồi trên VPS:
cd /opt/knowledge-graph
```

---

## 6. Tạo file .env (mật khẩu + bảo mật)

Trong thư mục chứa `docker-compose.prod.yml`:
```bash
cp .env.example .env
nano .env
```

Điền (đổi mật khẩu cho mạnh):
```env
DB_NAME=knowledge_graph
DB_USER=kguser
DB_PASS=DOI_MAT_KHAU_MANH_O_DAY
MYSQL_ROOT_PASSWORD=DOI_ROOT_PASS_MANH_O_DAY

# Để trống nếu không khoá API ghi. Xem mục Bảo mật bên dưới nếu muốn khoá.
API_TOKEN=
```
Lưu: `Ctrl+O`, `Enter`, thoát `Ctrl+X`.

---

## 7. Khởi chạy

```bash
docker compose -f docker-compose.prod.yml up -d --build
```

Lần đầu MySQL tự tạo bảng + nạp 105 node Q&A từ `seed.sql`. Caddy tự xin SSL cho hvnk.tech.

Theo dõi log (đợi Caddy lấy chứng chỉ xong):
```bash
docker compose -f docker-compose.prod.yml logs -f caddy
docker compose -f docker-compose.prod.yml ps
```

→ Mở trình duyệt: **https://hvnk.tech** 🎉 (có ổ khoá HTTPS)

---

## 8. Bảo mật — khoá truy cập (KHUYẾN NGHỊ)

App mặc định ai vào link cũng xem/sửa được. Chọn 1 trong 2:

### Cách A — Khoá cả trang bằng mật khẩu (đơn giản nhất)
1. Tạo hash mật khẩu:
   ```bash
   docker run --rm caddy caddy hash-password --plaintext 'matkhau_cua_ban'
   ```
2. Mở `Caddyfile`, bỏ comment khối `basicauth` và dán hash vào:
   ```
   basicauth {
       admin <DÁN_HASH_VÀO_ĐÂY>
   }
   ```
3. Nạp lại Caddy:
   ```bash
   docker compose -f docker-compose.prod.yml restart caddy
   ```
   Giờ vào hvnk.tech phải đăng nhập (user: `admin`).

### Cách B — Chỉ khoá thao tác GHI (xem thì mở)
1. Trong `.env`: đặt `API_TOKEN=mot_chuoi_bi_mat`.
2. Sửa `public/index.html`, dòng `const API_TOKEN = "";` → `const API_TOKEN = "mot_chuoi_bi_mat";`.
3. `docker compose -f docker-compose.prod.yml restart app`.

---

## 9. Cập nhật / vận hành

**Cập nhật code mới:**
```bash
cd /opt/knowledge-graph/kg_node
git pull                                   # nếu dùng git
docker compose -f docker-compose.prod.yml up -d --build
```
> Sửa `public/index.html` (frontend) thì chỉ cần **F5**, không phải rebuild (đã mount).

**Nạp lại data mẫu từ interview.docx (XOÁ data hiện tại):**
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
| Không vào được https, lỗi SSL | Kiểm tra DNS đã trỏ đúng IP chưa (`ping hvnk.tech`); cổng 80/443 đã mở (UFW + firewall hPanel). Xem `logs -f caddy`. |
| Caddy báo "challenge failed" | DNS chưa kịp cập nhật, hoặc cổng 80 bị chặn. Đợi DNS rồi `restart caddy`. |
| Trang trắng/đen | Xem Console trình duyệt (F12). Thường do mạng chặn CDN `esm.sh` — báo lại để chuyển sang tải thư viện về máy chủ. |
| App không nối được MySQL | `logs -f app`; kiểm tra `.env` đúng mật khẩu; `down` rồi `up` lại. |
| Đổi domain khác | Sửa tên miền trong `Caddyfile` rồi `restart caddy`. |

---

### Tóm tắt nhanh (sau khi DNS đã trỏ)
```bash
ssh root@<IP_VPS>
curl -fsSL https://get.docker.com | sh
cd /opt && git clone <REPO> kg && cd kg/kg_node
cp .env.example .env && nano .env          # đặt mật khẩu
ufw allow 80/tcp && ufw allow 443/tcp && ufw allow OpenSSH && ufw --force enable
docker compose -f docker-compose.prod.yml up -d --build
# -> https://hvnk.tech
```
