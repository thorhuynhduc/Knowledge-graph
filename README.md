# Knowledge Graph — Node.js + MySQL

Công cụ quản lý đồ thị kiến thức ôn thi Senior Full-Stack. Backend **Node.js (Express + mysql2)**, dữ liệu lưu trên **MySQL** — nhiều người truy cập cùng thấy chung dữ liệu.

## Cấu trúc

| File | Vai trò |
|------|---------|
| `server.js` | Express server: phục vụ frontend + API |
| `db.js` | Connection pool MySQL (mysql2) |
| `config.js` | Cấu hình DB / port / token (đọc từ env, có default) |
| `schema.sql` | 2 bảng `kg_nodes`, `kg_edges` |
| `public/index.html` | Giao diện (Cytoscape.js), gọi `/api` |
| `.env.example` | Mẫu biến môi trường |

## 🚀 Cách nhanh nhất — Docker (1 lệnh, kèm luôn MySQL)

Chỉ cần có Docker + Docker Compose, **không cần cài Node hay MySQL**:

```bash
cd kg_node
cp .env.example .env          # (tùy chọn) đổi mật khẩu/token
docker compose up -d --build
```

Mở **http://localhost:3000** → **đã có sẵn ~93 node + 121 quan hệ** seed từ `interview.docx`
(Node.js, NestJS, React, Behavioral & 2 dự án thực tế). Không cần bấm gì thêm!

> Lần đầu khởi động, MySQL tự chạy `schema.sql` (tạo bảng) rồi `seed.sql` (nạp dữ liệu).
> Muốn nạp lại từ đầu sau này: bấm **Reset Data** trên giao diện, hoặc `docker compose down -v && docker compose up -d`.

- Dữ liệu MySQL lưu trong volume `mysql_data` (không mất khi restart).
- Xem log: `docker compose logs -f app`
- Dừng: `docker compose down` · Xóa sạch cả dữ liệu: `docker compose down -v`
- Đổi cổng: đặt `APP_PORT=8080` trong `.env`.

> Bảng được tạo tự động vì `schema.sql` được mount vào `/docker-entrypoint-initdb.d`
> của MySQL container (chạy lần đầu khi volume còn trống).

---

## Yêu cầu (nếu chạy thủ công, không Docker)
- Node.js 18+ (cần cho `node --watch`; chạy thường thì 16+ là đủ)
- MySQL / MariaDB

## Cài đặt & chạy

```bash
cd kg_node
npm install
```

Tạo database (một lần) trong MySQL:
```sql
CREATE DATABASE knowledge_graph CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Cấu hình kết nối — chọn 1 trong 2 cách:

**Cách A — sửa trực tiếp** `config.js` (đổi `DB_USER`, `DB_PASS`...).

**Cách B — dùng biến môi trường:**
```bash
cp .env.example .env      # rồi điền giá trị
# Node 20.6+ tự nạp .env:
node --env-file=.env server.js
# hoặc set thẳng:
DB_USER=root DB_PASS=secret npm start
```

Khởi động:
```bash
npm start
# server: http://localhost:3000
```

Mở trình duyệt → bấm **Init DB** (tạo bảng) → **Load Sample** (nạp ~18 node mẫu). Xong!

## Chạy nền trên server (production)

Dùng **PM2** để giữ tiến trình sống và tự khởi động lại:
```bash
npm install -g pm2
pm2 start server.js --name knowledge-graph
pm2 save
pm2 startup        # làm theo hướng dẫn in ra để chạy cùng OS
```

Khuyến nghị đặt sau **Nginx reverse proxy** (HTTPS) trỏ về `localhost:3000`.

## Bảo mật (khi deploy public)
API mặc định **không** yêu cầu đăng nhập. Để chặn người lạ ghi dữ liệu:
1. Đặt `API_TOKEN` (trong `.env` hoặc `config.js`) = một chuỗi bí mật.
2. Sửa `public/index.html`, dòng `const API_TOKEN = "..."` cho khớp.

Mọi thao tác ghi (thêm/sửa/xóa) sẽ phải gửi đúng token. Thao tác đọc (xem graph) vẫn mở.

## API (tham khảo)
Cùng "hợp đồng" như bản PHP — tất cả qua `/api?action=...`:

| Action | Method | Body |
|--------|--------|------|
| `graph` | GET | — |
| `saveNode` | POST | `{id,label,category,description,links}` |
| `deleteNode` | POST | `{id}` |
| `savePosition` | POST | `{id,x,y}` |
| `addEdge` | POST | `{id,source,target,type}` |
| `deleteEdge` | POST | `{id}` |
| `replaceAll` | POST | `{elements:[...]}` |
| `setup` | POST | — |

## Ghi chú
- Kéo thả node → vị trí tự lưu vào DB.
- Export/Import JSON để sao lưu / di chuyển dữ liệu.
- Bản PHP nằm ở `../kg_server/`, bản LocalStorage offline ở `../knowledge-graph.html`.
