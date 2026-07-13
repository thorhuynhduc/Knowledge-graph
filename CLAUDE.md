# Knowledge Graph — CLAUDE.md

App đồ thị kiến thức (ôn thi Senior Full-Stack). Stack: **Node.js (Express + mysql2) + MySQL**, frontend SPA tĩnh dùng **3d-force-graph**. Toàn bộ comment/UI bằng tiếng Việt — giữ nguyên phong cách này khi sửa.

## Kiến trúc (5 file code, không build step)
| File | Vai trò |
|------|---------|
| `server.js` | Express: phục vụ `public/` + 1 endpoint `/api` phân nhánh theo `?action=` |
| `db.js` | Pool mysql2/promise (`multipleStatements:true`, `utf8mb4`) |
| `config.js` | Đọc env có default: `DB_*`, `PORT`(3000), `API_TOKEN`(rỗng=tắt) |
| `schema.sql` | 2 bảng `kg_nodes`, `kg_edges` (FK CASCADE: xóa node → xóa edge) |
| `seed.sql` | ~93 node + 121 edge seed sẵn (~38KB) |
| `public/index.html` | **Toàn bộ frontend trong 1 file** (~1000 dòng): HTML + Tailwind CDN + JS module 3d-force-graph |
| `public/login.html` | Trang đăng nhập (Tailwind CDN, không module). POST `/api/login`, thành công → redirect `/` |
| `public/manifest.webmanifest` + `public/icons/` + `public/sw.js` | PWA: manifest, bộ icon (tạo bằng PIL), service worker cache CDN |

Không có framework frontend, không bundler, không test. Sửa `public/index.html` → F5 là thấy (Docker mount read-only).

## Xác thực đăng nhập (server.js)
- Bắt buộc đăng nhập mới vào được app. Creds trong `.env`: `AUTH_USER` / `AUTH_PASS`.
- Cơ chế: **session cookie ký HMAC-SHA256** bằng `crypto` (không thư viện ngoài). Cookie `kg_session` (httpOnly, SameSite=Lax), giá trị `user|exp` + chữ ký. Khóa ký = `SESSION_SECRET` (env; trống → sinh ngẫu nhiên mỗi lần khởi động). Hạn = `SESSION_TTL_HOURS` (default 168h). `COOKIE_SECURE=true` khi sau HTTPS.
- Route công khai (trước cổng chặn): `GET /login`, `POST /api/login`, `POST /api/logout`, `GET /healthz` (healthcheck Docker), và tài nguyên PWA (`/manifest.webmanifest`, `/sw.js`, `/icons/*` — hàm `isPublicAsset`). Mọi route khác qua middleware gate: chưa đăng nhập → `/api*` trả 401 JSON, còn lại redirect `/login`.
- Chống brute-force: sai 5 lần/10 phút theo IP → khóa 5 phút (in-memory, reset khi restart). `trust proxy` bật khi `COOKIE_SECURE=true` (sau Caddy) để lấy IP thật.
- `.env` KHÔNG commit (đã gitignore); dùng `.env.example` làm mẫu.
- Frontend: `api()` trong index.html gặp 401 → tự chuyển `/login`; nút `#logoutBtn` POST `/api/logout` rồi về `/login`.

## API — 1 route `/api`, dispatch bằng `?action=`
Response thống nhất: `{ok:true,...}` hoặc `{ok:false,error}`. POST cần header `X-API-Token` nếu `API_TOKEN` được đặt.
- `GET  ?action=graph` → `{elements:[...]}` (cytoscape format: `{group:'nodes'|'edges', data, position}`)
- `POST ?action=saveNode` (upsert) · `deleteNode` · `savePosition` (x,y) · `addEdge` (upsert) · `deleteEdge`
- `POST ?action=replaceAll` (xóa hết + insert lại trong transaction; Import/Reset) · `setup` (chạy schema.sql tạo bảng)

## Dữ liệu
- Node: `id, label, category, description, links(JSON array), pos_x, pos_y`
- Edge: `id, source, target, type`
- `category` ∈ {Frontend, Backend, Database, System Design, DevOps & Cloud, Architecture, Behavioral} — màu định nghĩa trong `CATEGORIES` (index.html). Default `Frontend`.
- `edge.type` ∈ {prerequisite, related, advanced, tool-of, part-of} — `EDGE_COLORS`. Default `related`.
- Frontend coi mảng `raw` (cytoscape elements) là nguồn sự thật, convert sang `{nodes,links}` cho 3d-force-graph.

## Chạy
- Docker (kèm MySQL, seed tự nạp): `docker compose up -d --build` → http://localhost:3000
- Node trực tiếp: `npm install` rồi `node --env-file=.env server.js` (cần MySQL sẵn). Dev: `npm run dev` (--watch).
- Reset data: nút **Reset Data** trên UI, hoặc `docker compose down -v && docker compose up -d`.
- Đổi cổng host: `APP_PORT` trong `.env`. Deploy: `DEPLOY.md` — (A) Caddy/Docker (`docker-compose.prod.yml`) hoặc (B) **Nginx host + Certbot Docker** (theo convention Course-online): app+mysql qua `docker-compose.nginx.yml` (app bind `127.0.0.1:3000`); `deploy/certbot/` (init-cert.sh, renew.sh qua cron), `deploy/nginx/` (init-http.conf tạm + hvnk.tech.conf SSL), `deploy/scripts/deploy.sh`; code ở `/var/www/knowledge`. Xem `deploy/README.md`.

## Responsive / Mobile (index.html)
- < 768px: sidebar biến thành **drawer trượt** (CSS `@media` + class `body.sidebar-open`). Mở bằng nút `#menuToggle` (hamburger nổi góc trên-trái), đóng bằng `#sidebarClose` (X trong header), click `#sidebarBackdrop`, hoặc phím Esc. Resize ≥768px tự bỏ trạng thái mở.
- Drawer/backdrop z-index 50/45, modal chi tiết `#nodeModal` z-`[60]` (luôn trên cùng); trên mobile modal bám đáy màn hình. Mở chi tiết node sẽ tự đóng drawer.
- Graph (`#cy`) luôn full-screen (drawer phủ lên, không co main) nên không cần resize lại canvas khi mở menu.

## PWA + hiệu năng mobile (index.html)
- **PWA**: `manifest.webmanifest` (standalone, theme `#05070d`) + meta iOS (`apple-mobile-web-app-*`, `apple-touch-icon`, `viewport-fit=cover` + CSS `env(safe-area-inset-*)` cho notch). iPhone: Safari → Share → "Thêm vào MH chính" → mở full-screen như app. Icon tạo lại bằng `python3` + PIL nếu cần đổi.
- **Service worker** (`sw.js`): cache-first CHỈ cho CDN (esm.sh, tailwind, cdnjs) + `/icons/`; HTML và `/api` luôn ra mạng (tránh vấn đề auth/dữ liệu cũ). Đổi nội dung cache → tăng version tên `CACHE` (`kg-static-v1`).
- **Tối ưu mobile** (`IS_MOBILE` = pointer coarse hoặc màn < 768px): cap `setPixelRatio` 1.5 (desktop 2) — thủ phạm lag chính trên iPhone (dpr=3 → 9× pixel); tắt antialias; `nodeResolution` 8 (desktop 14); particles mặc định TẮT; `cooldownTime` 8s; `pauseAnimation()` khi tab ẩn (mọi thiết bị).

## Điều hướng / Focus (index.html)
- "Bay tới" (`focusNeighborhood`) → highlight node + hàng xóm, chỉ hiện label nhóm đó (`focusLabels`), rồi `flyTo` canh khung theo FOV ngang (node biên cách mép trái/phải ~10px, `margin` chỉnh được).
- Ngăn xếp `focusHistory` + `currentFocusId` lưu các lần Bay tới; nút `#backBtn` (góc trên-trái graph) gọi `goBack()` về view trước (node cha hoặc tổng quan). Click nền (`clearHighlight`) hoặc tìm kiếm sẽ reset lịch sử.

## Tiện ích frontend (index.html)
- Tìm kiếm: chỉ theo `label`, debounce 160ms, có **danh sách kết quả** (`#searchResults`, top 8) — click hoặc ↑/↓ + Enter để focus. Phím `/` nhảy vào ô tìm kiếm.
- **WebGL**: `webglOK()` kiểm tra trước khi `initGraph`; thiếu → `showWebglError()` (thông báo thân thiện) và `Graph=null`. Các hàm dùng Graph đều guard `if (!Graph)` để app vẫn chạy được phần còn lại.

## Lưu ý khi sửa
- Sửa thêm action: thêm `case` trong `switch` ở `server.js`. Đổi schema: sửa cả `schema.sql` và phần insert tương ứng.
- `API_TOKEN` xuất hiện 2 nơi phải khớp: env (backend) và `const API_TOKEN` trong `public/index.html`.
- README.md nói "Cytoscape.js" nhưng frontend thực tế render bằng **3d-force-graph** (cytoscape chỉ là format dữ liệu).
