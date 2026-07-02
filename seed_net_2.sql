-- TOPIC Network file 2: Infra
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_net_nat_fw','NAT & Firewall','System Design',
'NAT và Firewall là hai cơ chế nền tảng ở BIÊN mạng.

NAT (Network Address Translation): dịch IP private <-> public, cho NHIỀU
thiết bị nội bộ (192.168.x) chia sẻ MỘT IP public ra Internet.
  Máy nội bộ 192.168.1.5 -> router NAT -> ra Internet bằng IP public của router
  -> router nhớ ánh xạ để trả gói về đúng máy nội bộ.
  Đây là lý do IPv4 chưa cạn dù ít địa chỉ, và máy nhà bạn không có IP public riêng.

FIREWALL: lọc lưu lượng theo LUẬT (cho phép/chặn) dựa trên IP, port, protocol.
  • Nguyên tắc: mặc định CHẶN, chỉ MỞ cổng thật sự cần (vd chỉ 443 vào web).
  • Stateful firewall: nhớ kết nối đang mở -> tự cho gói TRẢ VỀ của kết nối
    do bên trong khởi tạo.
  • Security Group (AWS) là firewall ảo ở mức instance.

VÍ DỤ luật: "inbound: cho phép TCP 443 từ mọi nơi; cho SSH 22 chỉ từ IP văn
phòng; chặn phần còn lại".

MẸO: theo "least privilege" — mặc định chặn, chỉ mở cổng/nguồn cần thiết.
NAT + firewall ở gateway là lớp bảo vệ cơ bản của mọi mạng nội bộ / VPC.',
'NAT and Firewall are two foundational mechanisms at the network EDGE.

NAT (Network Address Translation): translates private <-> public IPs so MANY
internal devices (192.168.x) share ONE public IP to the Internet.
  Internal host 192.168.1.5 -> NAT router -> reaches the Internet as the router public IP
  -> the router remembers the mapping to return packets to the right host.
  This is why IPv4 has not run out despite few addresses, and why your home
  machine has no public IP of its own.

FIREWALL: filters traffic by RULES (allow/deny) based on IP, port, protocol.
  • Principle: deny by default, only OPEN ports truly needed (e.g. only 443 to web).
  • Stateful firewall: remembers open connections -> automatically allows the
    RETURN packets of connections initiated from inside.
  • A Security Group (AWS) is a virtual instance-level firewall.

EXAMPLE RULES: "inbound: allow TCP 443 from anywhere; allow SSH 22 only from
the office IP; deny the rest".

TIP: follow "least privilege" - deny by default, open only necessary
ports/sources. NAT + firewall at the gateway is the basic protection layer of
any internal network / VPC.',
'[]',400,220),

('n_net_lb','Load Balancer','System Design',
'Load Balancer (cân bằng tải) phân phối request tới NHIỀU server backend
-> chịu tải cao + sẵn sàng cao (một server chết vẫn còn server khác).

  Client -> [ Load Balancer ] -> Server 1 / Server 2 / Server 3

THUẬT TOÁN phân phối:
  • Round-robin      : lần lượt từng server.
  • Least connections: chọn server ít kết nối nhất.
  • IP hash          : theo IP client (giữ "dính" một client vào một server).

TẦNG:
  • L4 (transport)  : cân bằng theo IP/port, nhanh, không nhìn nội dung.
  • L7 (application): hiểu HTTP -> định tuyến theo path/host/header
    (vd /api -> nhóm A, /img -> nhóm B).

HEALTH CHECK: LB tự kiểm tra server, NGỪNG gửi request tới server hỏng.
STICKY SESSION: giữ user vào cùng một server (khi state nằm ở server) —
nhưng tốt hơn là làm server STATELESS.

MẸO: LB là nền của SCALE NGANG + HA. Trên AWS: ALB (L7), NLB (L4). Kết hợp
auto-scaling (thêm/bớt server theo tải). Muốn scale mượt -> server nên
STATELESS (đẩy state sang DB/Redis) để gửi request tới server nào cũng được.',
'A load balancer distributes requests across MANY backend servers -> handles
high load + high availability (one server dies, others remain).

  Client -> [ Load Balancer ] -> Server 1 / Server 2 / Server 3

DISTRIBUTION ALGORITHMS:
  • Round-robin      : each server in turn.
  • Least connections: pick the server with the fewest connections.
  • IP hash          : by client IP (keeps a client "stuck" to one server).

LAYERS:
  • L4 (transport)  : balances by IP/port, fast, does not inspect content.
  • L7 (application): understands HTTP -> routes by path/host/header
    (e.g. /api -> group A, /img -> group B).

HEALTH CHECKS: the LB probes servers and STOPS sending to unhealthy ones.
STICKY SESSIONS: pin a user to one server (when state lives on the server) -
but making servers STATELESS is better.

TIP: the LB underpins HORIZONTAL scaling + HA. On AWS: ALB (L7), NLB (L4).
Combine with auto-scaling (add/remove servers by load). For smooth scaling,
make servers STATELESS (push state to DB/Redis) so any server can handle any
request.',
'[]',560,220),

('n_net_proxy','Forward vs Reverse Proxy','System Design',
'Proxy là máy trung gian giữa client và server, chuyển tiếp request. Có hai
loại NGƯỢC nhau:

FORWARD PROXY (đại diện cho CLIENT):
  Client -> [Forward Proxy] -> Internet
  • Ẩn/gom client, lọc nội dung, cache, vượt chặn (VPN / corporate proxy).

REVERSE PROXY (đại diện cho SERVER):
  Client -> [Reverse Proxy] -> Server nội bộ
  • Đứng TRƯỚC server: định tuyến, TLS termination (giải mã HTTPS), cache,
    nén, rate limit, ẩn cấu trúc backend.
  • Nginx, Caddy, HAProxy hay dùng làm reverse proxy (như Nginx/Caddy trong
    phần deploy của app này).

KHÁC LOAD BALANCER: reverse proxy CÓ THỂ kiêm cân bằng tải; LB tập trung vào
phân phối. Nhiều công cụ (Nginx) làm cả hai vai.

VÍ DỤ: Nginx nhận cổng 443 (HTTPS), giải mã TLS, rồi chuyển tiếp HTTP nội bộ
tới app ở 127.0.0.1:3000.

MẸO: "forward = cho client, reverse = cho server". Reverse proxy là nơi đặt
TLS, cache, rate limit và định tuyến tới nhiều service — cực phổ biến trong
kiến trúc web/microservices.',
'A proxy is an intermediary between client and server that forwards requests.
There are two OPPOSITE kinds:

FORWARD PROXY (acts on behalf of the CLIENT):
  Client -> [Forward Proxy] -> Internet
  • Hides/aggregates clients, filters content, caches, bypasses blocks
    (VPN / corporate proxy).

REVERSE PROXY (acts on behalf of the SERVER):
  Client -> [Reverse Proxy] -> internal servers
  • Sits IN FRONT of servers: routing, TLS termination (decrypts HTTPS),
    caching, compression, rate limiting, hiding the backend layout.
  • Nginx, Caddy, HAProxy are common reverse proxies (like Nginx/Caddy in this
    app deploy).

VS A LOAD BALANCER: a reverse proxy CAN also load-balance; an LB focuses on
distribution. Many tools (Nginx) do both.

EXAMPLE: Nginx accepts port 443 (HTTPS), terminates TLS, then forwards plain
HTTP internally to an app at 127.0.0.1:3000.

TIP: "forward = for the client, reverse = for the server". A reverse proxy is
where you place TLS, caching, rate limiting, and routing to many services -
extremely common in web/microservice architectures.',
'[]',600,180),

('n_net_cdn','CDN','System Design',
'CDN (Content Delivery Network) là mạng lưới server đặt ở NHIỀU nơi trên
thế giới (edge / PoP), cache nội dung GẦN người dùng -> tải nhanh, giảm tải
server gốc.

CÁCH HOẠT ĐỘNG:
  User ở VN -> CDN edge tại VN (có cache?) -> trả ngay nếu có
                     | (cache miss)
                     -> lấy từ ORIGIN (server gốc, vd ở Mỹ) rồi cache lại
  -> user VN tiếp theo lấy từ edge VN, không phải "bay" sang Mỹ.

CACHE GÌ: chủ yếu STATIC (ảnh, CSS, JS, video, file). Nội dung động thường
không cache hoặc cache rất ngắn.

LỢI ÍCH:
  • Độ trễ thấp (gần người dùng về địa lý).
  • Giảm tải + băng thông cho origin.
  • Chịu tải đột biến, chống DDoS một phần.

CACHE CONTROL: header Cache-Control / ETag quyết định cache bao lâu; cần
"invalidate" hoặc đổi tên file (thêm hash) khi cập nhật.

VÍ DỤ: CloudFront (AWS), Cloudflare, Fastly, Akamai.

MẸO: đưa asset tĩnh lên CDN là cách tăng tốc web đơn giản mà hiệu quả nhất.
Dùng "cache busting" (thêm hash vào tên file: app.3f9a.js) để user luôn nhận
bản mới sau khi deploy.',
'A CDN (Content Delivery Network) is a network of servers in MANY locations
worldwide (edge / PoP) caching content CLOSE to users -> faster loads, less
load on the origin server.

HOW IT WORKS:
  User in VN -> CDN edge in VN (cached?) -> serve immediately if present
                     | (cache miss)
                     -> fetch from ORIGIN (e.g. in the US) then cache it
  -> the next VN user is served from the VN edge, no round-trip to the US.

WHAT IS CACHED: mostly STATIC assets (images, CSS, JS, video, files). Dynamic
content is usually not cached or cached very briefly.

BENEFITS:
  • Low latency (geographically near users).
  • Less load + bandwidth on the origin.
  • Absorbs traffic spikes, partial DDoS protection.

CACHE CONTROL: Cache-Control / ETag headers decide how long to cache; you must
"invalidate" or rename files (add a hash) on updates.

EXAMPLES: CloudFront (AWS), Cloudflare, Fastly, Akamai.

TIP: putting static assets on a CDN is the simplest, most effective web
speedup. Use "cache busting" (a hash in the filename: app.3f9a.js) so users
always get the new build after a deploy.',
'[]',540,160)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
