-- ===================================================================
--  TOPIC: Network (song ngữ VI + EN, sơ đồ). File 1: cấu trúc + Model + App
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_net','Mạng máy tính (Network)','System Design',
'Kiến thức mạng cho lập trình web: mô hình OSI/TCP-IP, IP & subnet, TCP vs
UDP, cổng, DNS, HTTP/HTTPS & TLS, REST, cùng hạ tầng NAT/firewall, load
balancer, proxy và CDN.',
'Networking for web developers: the OSI/TCP-IP models, IP & subnets, TCP vs
UDP, ports, DNS, HTTP/HTTPS & TLS, REST, plus infrastructure - NAT/firewall,
load balancers, proxies, and CDNs.',
'[]',480,360),

('s_net_model','Mô hình & Giao thức nền','System Design',
'Mô hình OSI/TCP-IP, địa chỉ IP & subnet, TCP vs UDP, và cổng (ports).',
'The OSI/TCP-IP models, IP addressing & subnets, TCP vs UDP, and ports.',
'[]',380,300),
('s_net_app','Tầng ứng dụng (Web)','System Design',
'DNS, HTTP/HTTPS, TLS/SSL và thiết kế REST API.',
'DNS, HTTP/HTTPS, TLS/SSL, and REST API design.',
'[]',580,300),
('s_net_infra','Hạ tầng mạng','System Design',
'NAT & firewall, load balancer, forward/reverse proxy, và CDN.',
'NAT & firewall, load balancers, forward/reverse proxies, and CDNs.',
'[]',480,240),

-- ------------------------- MODEL ----------------------------------
('n_net_model','Mô hình OSI & TCP/IP','System Design',
'Mô hình phân tầng mô tả dữ liệu đi qua mạng theo các lớp, mỗi lớp một
nhiệm vụ riêng.

TCP/IP (4 tầng — thực dụng, dùng thật):
  4. Application : HTTP, DNS, SMTP, SSH (dữ liệu ứng dụng)
  3. Transport   : TCP / UDP (cổng, độ tin cậy)
  2. Internet    : IP (định tuyến gói giữa các mạng, địa chỉ IP)
  1. Link        : Ethernet / WiFi (khung, địa chỉ MAC, vật lý)

OSI (7 tầng — lý thuyết, hay hỏi phỏng vấn):
  7 Application | 6 Presentation | 5 Session | 4 Transport
  3 Network | 2 Data Link | 1 Physical

ĐÓNG GÓI (encapsulation): mỗi tầng thêm header của nó khi gửi XUỐNG, gỡ ra
khi nhận LÊN:
  [App data] -> +TCP header -> +IP header -> +Ethernet header -> bit lên dây

DÒNG CHẢY: dữ liệu app -> chia segment (TCP) -> đóng gói (IP, thêm địa chỉ
đích) -> khung (MAC) -> tín hiệu; bên nhận gỡ ngược lại từng tầng.

MẸO: nhớ 4 tầng TCP/IP là đủ dùng thực tế. HTTP ở tầng App, chạy TRÊN TCP
(Transport), TCP chạy trên IP (Internet). Biết tầng nào lo gì giúp debug
đúng chỗ: mất gói -> Transport; sai route -> Internet; phân giải tên -> App.',
'A layered model describes data crossing a network in layers, each with one
job.

TCP/IP (4 layers - practical, used in reality):
  4. Application : HTTP, DNS, SMTP, SSH (application data)
  3. Transport   : TCP / UDP (ports, reliability)
  2. Internet    : IP (routing packets between networks, IP addresses)
  1. Link        : Ethernet / WiFi (frames, MAC addresses, physical)

OSI (7 layers - theoretical, common in interviews):
  7 Application | 6 Presentation | 5 Session | 4 Transport
  3 Network | 2 Data Link | 1 Physical

ENCAPSULATION: each layer adds its header going DOWN and strips it going UP:
  [App data] -> +TCP header -> +IP header -> +Ethernet header -> bits on the wire

FLOW: app data -> split into segments (TCP) -> packets (IP, adds the
destination address) -> frames (MAC) -> signals; the receiver unwraps each
layer in reverse.

TIP: knowing the 4 TCP/IP layers is enough in practice. HTTP is at the App
layer, runs OVER TCP (Transport), which runs over IP (Internet). Knowing
which layer does what helps debug: packet loss -> Transport; bad route ->
Internet; name resolution -> App.',
'[]',320,340),

('n_net_ip','Địa chỉ IP & Subnet','System Design',
'Địa chỉ IP định danh một thiết bị trên mạng để gói tin tìm đường tới.
IPv4: 4 số 0-255 (32-bit), vd 192.168.1.10. IPv6: 128-bit (vô số địa chỉ),
vd 2001:db8::1.

PUBLIC vs PRIVATE:
  • Private (mạng nội bộ, không ra Internet trực tiếp):
    10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
  • Public: cấp phát toàn cầu, định tuyến được trên Internet.
  • Loopback: 127.0.0.1 (localhost).

SUBNET & CIDR: /n = số bit của phần MẠNG; phần còn lại là HOST.
  192.168.1.0/24  -> 24 bit mạng, 8 bit host -> 256 địa chỉ (254 dùng được)
  10.0.0.0/16     -> 65,536 địa chỉ
  -> số sau "/" càng LỚN thì mạng càng NHỎ (ít host hơn).
  subnet mask của /24 = 255.255.255.0

Ý NGHĨA: chia subnet để tách mạng, kiểm soát định tuyến & bảo mật (vd VPC
trên AWS chia subnet public/private).
GATEWAY: cổng ra (router) để gói rời mạng nội bộ; DHCP tự cấp IP cho thiết bị.

MẸO: nhớ 3 dải private + 127.0.0.1. CIDR /24 (256 IP) rất hay gặp trong
LAN/VPC. Càng nhiều bit mạng (/n lớn) -> càng ít địa chỉ host khả dụng.',
'An IP address identifies a device on a network so packets can find their
way. IPv4: four 0-255 numbers (32-bit), e.g. 192.168.1.10. IPv6: 128-bit
(vast address space), e.g. 2001:db8::1.

PUBLIC vs PRIVATE:
  • Private (internal, not directly on the Internet):
    10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
  • Public: globally allocated, routable on the Internet.
  • Loopback: 127.0.0.1 (localhost).

SUBNET & CIDR: /n = the number of NETWORK bits; the rest is HOST.
  192.168.1.0/24  -> 24 network bits, 8 host bits -> 256 addresses (254 usable)
  10.0.0.0/16     -> 65,536 addresses
  -> a LARGER number after "/" means a SMALLER network (fewer hosts).
  the /24 subnet mask = 255.255.255.0

MEANING: subnetting separates networks and controls routing & security
(e.g. an AWS VPC splits public/private subnets).
GATEWAY: the exit (router) for packets leaving the local network; DHCP
auto-assigns IPs to devices.

TIP: memorize the 3 private ranges + 127.0.0.1. CIDR /24 (256 IPs) is very
common in LANs/VPCs. More network bits (larger /n) -> fewer usable host
addresses.',
'[]',300,300),

('n_net_tcp_udp','TCP vs UDP','System Design',
'Tầng Transport có hai giao thức chính, đánh đổi TIN CẬY vs TỐC ĐỘ.

TCP (Transmission Control Protocol) — tin cậy, CÓ kết nối:
  • Bắt tay 3 bước trước khi truyền: SYN -> SYN-ACK -> ACK
  • Đảm bảo đến ĐỦ, ĐÚNG THỨ TỰ, không trùng; tự truyền lại gói mất; kiểm
    soát tắc nghẽn.
  • Dùng cho: HTTP/HTTPS, SSH, email, DB — nơi cần chính xác.

UDP (User Datagram Protocol) — nhanh, KHÔNG kết nối:
  • Gửi luôn, KHÔNG bắt tay, KHÔNG đảm bảo đến/thứ tự.
  • Nhẹ, độ trễ thấp.
  • Dùng cho: video/voice call, game realtime, DNS, streaming — nơi tốc độ
    quan trọng hơn việc mất vài gói.

SO SÁNH nhanh:
  TCP: chậm hơn, nặng hơn, ĐÁNG TIN   -> như "gọi điện xác nhận từng câu"
  UDP: nhanh, nhẹ, CÓ THỂ MẤT gói     -> như "phát loa, ai nghe kịp thì nghe"

HTTP/3 (QUIC) chạy trên UDP nhưng tự thêm độ tin cậy ở tầng trên.

MẸO: cần dữ liệu nguyên vẹn -> TCP; cần realtime chấp nhận mất mát -> UDP.
Câu phỏng vấn kinh điển: mô tả 3-way handshake và khác biệt TCP/UDP.',
'The Transport layer has two main protocols, trading RELIABILITY vs SPEED.

TCP (Transmission Control Protocol) - reliable, CONNECTION-oriented:
  • A 3-way handshake before sending: SYN -> SYN-ACK -> ACK
  • Guarantees COMPLETE, IN-ORDER, non-duplicated delivery; retransmits lost
    packets; congestion control.
  • Used for: HTTP/HTTPS, SSH, email, DBs - where accuracy matters.

UDP (User Datagram Protocol) - fast, CONNECTIONLESS:
  • Just sends, NO handshake, NO delivery/order guarantee.
  • Lightweight, low latency.
  • Used for: video/voice calls, realtime games, DNS, streaming - where speed
    beats losing a few packets.

QUICK COMPARISON:
  TCP: slower, heavier, RELIABLE   -> like "a phone call confirming each line"
  UDP: fast, light, MAY LOSE packets -> like "a loudspeaker - catch it if you can"

HTTP/3 (QUIC) runs over UDP but adds its own reliability on top.

TIP: need intact data -> TCP; need realtime tolerating loss -> UDP. A classic
interview question: describe the 3-way handshake and the TCP/UDP difference.',
'[]',360,260),

('n_net_ports','Cổng (Ports)','System Design',
'Cổng (port) là số 0-65535 giúp một máy (một IP) phân biệt NHIỀU dịch vụ /
kết nối cùng lúc. IP tìm đúng MÁY, port tìm đúng ỨNG DỤNG.
  Một kết nối được xác định bởi bộ 4: (IP nguồn, port nguồn, IP đích, port đích).

CỔNG PHỔ BIẾN (well-known, 0-1023):
  80   HTTP         443  HTTPS        22   SSH
  53   DNS          25   SMTP         3306 MySQL
  5432 PostgreSQL   6379 Redis        27017 MongoDB
  3000 / 8080 thường dùng cho app khi dev

PHÂN LOẠI:
  0-1023      well-known (dịch vụ hệ thống)
  1024-49151  registered
  49152-65535 ephemeral (client tự cấp tạm cho kết nối ra)

VÍ DỤ: trình duyệt mở kết nối từ một port ngẫu nhiên (vd 51000) tới server
port 443; server trả về đúng kết nối đó nhờ bộ 4 nói trên.
LIÊN HỆ DOCKER: "-p 8080:80" map port 8080 của host -> port 80 của container.

MẸO: thuộc vài port hay gặp (80/443/22/3306/5432/6379). "IP:cổng" giống
"tòa nhà:số phòng". Firewall thường lọc theo port (mở 443, chặn phần còn lại).',
'A port is a number 0-65535 that lets one machine (one IP) distinguish MANY
services / connections at once. IP finds the right MACHINE, the port finds
the right APPLICATION.
  A connection is identified by a 4-tuple: (src IP, src port, dst IP, dst port).

COMMON PORTS (well-known, 0-1023):
  80   HTTP         443  HTTPS        22   SSH
  53   DNS          25   SMTP         3306 MySQL
  5432 PostgreSQL   6379 Redis        27017 MongoDB
  3000 / 8080 often used for apps during development

RANGES:
  0-1023      well-known (system services)
  1024-49151  registered
  49152-65535 ephemeral (client-assigned temporarily for outbound connections)

EXAMPLE: a browser opens a connection from a random port (e.g. 51000) to the
server port 443; the server replies to that exact connection via the 4-tuple.
DOCKER LINK: "-p 8080:80" maps host port 8080 -> container port 80.

TIP: memorize a few common ports (80/443/22/3306/5432/6379). "IP:port" is
like "building:room number". Firewalls often filter by port (open 443, block
the rest).',
'[]',420,300),

-- ------------------------- APP ------------------------------------
('n_net_dns','DNS','System Design',
'DNS (Domain Name System) là "danh bạ" của Internet: dịch tên miền
(google.com) sang địa chỉ IP mà máy dùng để kết nối. Người nhớ tên, máy
cần IP.

PHÂN GIẢI (khi gõ example.com):
  1. Trình duyệt/OS xem CACHE cục bộ -> có thì dùng luôn.
  2. Hỏi RESOLVER (thường của ISP, hoặc 8.8.8.8 / 1.1.1.1).
  3. Resolver hỏi ROOT -> TLD (.com) -> NAMESERVER của domain.
  4. Nhận IP -> trả về -> trình duyệt kết nối tới IP đó.
  (kết quả được cache theo TTL để lần sau nhanh hơn)

CÁC BẢN GHI (records):
  A     tên -> IPv4          AAAA  tên -> IPv6
  CNAME bí danh -> tên khác  MX    máy chủ mail
  TXT   văn bản (SPF, xác minh)   NS   nameserver
  -> A/AAAA và CNAME là hay gặp nhất.

TTL: thời gian cache một bản ghi (giây). TTL thấp -> đổi IP lan nhanh nhưng
nhiều truy vấn hơn.

MẸO: đổi DNS cần thời gian "lan" (propagation) do cache/TTL. Công cụ:
nslookup, dig. DNS chạy chủ yếu trên UDP cổng 53. CDN/load balancer thường
dùng CNAME + DNS để định tuyến người dùng.',
'DNS (Domain Name System) is the Internet "phone book": it translates a
domain name (google.com) into the IP address a machine uses to connect.
People remember names, machines need IPs.

RESOLUTION (when you type example.com):
  1. The browser/OS checks its local CACHE -> use it if present.
  2. Ask a RESOLVER (usually the ISP, or 8.8.8.8 / 1.1.1.1).
  3. The resolver asks ROOT -> TLD (.com) -> the domain NAMESERVER.
  4. Gets the IP -> returns it -> the browser connects to that IP.
  (the result is cached per TTL to be faster next time)

RECORDS:
  A     name -> IPv4         AAAA  name -> IPv6
  CNAME alias -> another name MX   mail server
  TXT   text (SPF, verification)   NS   nameserver
  -> A/AAAA and CNAME are the most common.

TTL: how long a record is cached (seconds). A low TTL -> IP changes propagate
fast but cause more queries.

TIP: DNS changes need "propagation" time due to caching/TTL. Tools: nslookup,
dig. DNS runs mostly over UDP port 53. CDNs/load balancers often use CNAME +
DNS to route users.',
'[]',560,340),

('n_net_http','HTTP & Status Codes','System Design',
'HTTP là giao thức tầng ứng dụng cho web: client gửi REQUEST, server trả
RESPONSE (mô hình request/response, PHI TRẠNG THÁI - stateless).

CẤU TRÚC REQUEST:
  GET /users/42 HTTP/1.1          <- method + path + version
  Host: api.example.com           <- headers
  Authorization: Bearer <token>
  (body — với POST/PUT)

METHODS: GET (đọc), POST (tạo), PUT (thay toàn bộ), PATCH (sửa một phần),
DELETE (xóa), HEAD, OPTIONS.

RESPONSE:
  HTTP/1.1 200 OK                 <- status code
  Content-Type: application/json
  {"id":42, ...}                  <- body

STATUS CODES (theo nhóm):
  2xx thành công : 200 OK, 201 Created, 204 No Content
  3xx chuyển hướng: 301 (vĩnh viễn), 302 (tạm), 304 Not Modified
  4xx lỗi CLIENT : 400 Bad Request, 401 Unauthorized, 403 Forbidden,
                   404 Not Found, 429 Too Many Requests
  5xx lỗi SERVER : 500 Internal, 502 Bad Gateway, 503 Unavailable

STATELESS: mỗi request độc lập -> giữ phiên bằng cookie/token.
PHIÊN BẢN: HTTP/1.1 (text), HTTP/2 (nhị phân, đa luồng trên 1 kết nối),
HTTP/3 (trên QUIC/UDP).

MẸO: nhớ ý nghĩa nhóm status (4xx tại CLIENT, 5xx tại SERVER) để debug
nhanh. Dùng method đúng ngữ nghĩa (GET không được làm đổi dữ liệu).',
'HTTP is the web application-layer protocol: the client sends a REQUEST, the
server returns a RESPONSE (request/response model, STATELESS).

REQUEST STRUCTURE:
  GET /users/42 HTTP/1.1          <- method + path + version
  Host: api.example.com           <- headers
  Authorization: Bearer <token>
  (body — with POST/PUT)

METHODS: GET (read), POST (create), PUT (replace whole), PATCH (partial
update), DELETE (remove), HEAD, OPTIONS.

RESPONSE:
  HTTP/1.1 200 OK                 <- status code
  Content-Type: application/json
  {"id":42, ...}                  <- body

STATUS CODES (by class):
  2xx success  : 200 OK, 201 Created, 204 No Content
  3xx redirect : 301 (permanent), 302 (temporary), 304 Not Modified
  4xx CLIENT error: 400 Bad Request, 401 Unauthorized, 403 Forbidden,
                    404 Not Found, 429 Too Many Requests
  5xx SERVER error: 500 Internal, 502 Bad Gateway, 503 Unavailable

STATELESS: each request is independent -> keep sessions via cookies/tokens.
VERSIONS: HTTP/1.1 (text), HTTP/2 (binary, multiplexed on one connection),
HTTP/3 (over QUIC/UDP).

TIP: remember the status classes (4xx is CLIENT, 5xx is SERVER) to debug
fast. Use methods per their semantics (GET must not change data).',
'[]',620,300),

('n_net_tls','TLS / HTTPS','System Design',
'TLS/SSL mã hóa kết nối -> HTTPS = HTTP chạy TRÊN TLS. Bảo vệ 3 điều: BÍ MẬT
(mã hóa), TOÀN VẸN (không bị sửa), XÁC THỰC (đúng server nhờ certificate).

TLS HANDSHAKE (rút gọn):
  1. Client Hello: gửi phiên bản TLS + danh sách cipher hỗ trợ.
  2. Server gửi CERTIFICATE (chứa public key, do CA ký).
  3. Client kiểm tra cert: CA có tin cậy? đúng domain? còn hạn?
  4. Hai bên thống nhất KHÓA PHIÊN (session key) qua mã hóa bất đối xứng.
  5. Truyền dữ liệu bằng mã hóa ĐỐI XỨNG (nhanh) với session key.

CHỨNG CHỈ: CA (Certificate Authority) ký xác nhận domain. "Let''s Encrypt"
cấp miễn phí (Certbot tự gia hạn — như trong phần deploy của app này).

MÃ HÓA:
  • Bất đối xứng (public/private key): dùng lúc handshake để trao khóa.
  • Đối xứng (một khóa chung): dùng cho dữ liệu (nhanh hơn nhiều).

MẸO: HTTPS (ổ khóa) nghĩa là kết nối được mã hóa + server đã được xác thực
(KHÔNG bảo đảm website "tốt/an toàn về nội dung"). Luôn dùng HTTPS. Cert hết
hạn -> trình duyệt cảnh báo -> nhớ auto-renew (Certbot).',
'TLS/SSL encrypts the connection -> HTTPS = HTTP OVER TLS. It protects three
things: CONFIDENTIALITY (encryption), INTEGRITY (not tampered), AUTHENTICITY
(the right server, via a certificate).

TLS HANDSHAKE (simplified):
  1. Client Hello: sends the TLS version + supported cipher list.
  2. The server sends its CERTIFICATE (contains a public key, signed by a CA).
  3. The client verifies the cert: trusted CA? right domain? not expired?
  4. Both agree on a SESSION KEY via asymmetric encryption.
  5. Data is transferred with SYMMETRIC encryption (much faster) using that key.

CERTIFICATES: a CA (Certificate Authority) signs to vouch for a domain.
"Let''s Encrypt" issues them free (Certbot auto-renews - as in this app deploy).

ENCRYPTION:
  • Asymmetric (public/private key): used during the handshake to exchange a key.
  • Symmetric (one shared key): used for the data (much faster).

TIP: HTTPS (the padlock) means the connection is encrypted + the server is
authenticated (it does NOT guarantee the site content is "safe/good").
Always use HTTPS. An expired cert -> browser warning -> remember auto-renew
(Certbot).',
'[]',640,260),

('n_net_rest','Thiết kế REST API','System Design',
'REST là kiểu thiết kế API dựa trên HTTP: coi mọi thứ là TÀI NGUYÊN
(resource) có URL, thao tác bằng HTTP method.

NGUYÊN TẮC:
  • Resource là DANH TỪ, số nhiều: /users, /users/42, /users/42/orders
  • Method mang ngữ nghĩa hành động (ĐỪNG nhét động từ vào URL):
      GET    /users        lấy danh sách
      GET    /users/42     lấy một user
      POST   /users        tạo mới
      PUT    /users/42     thay toàn bộ
      PATCH  /users/42     sửa một phần
      DELETE /users/42     xóa
  ✗ /getUser?id=42 hay /createUser    ✓ GET /users/42, POST /users
  • Stateless: request tự chứa đủ thông tin (token); server không giữ phiên.
  • Trả status code đúng (201 khi tạo, 404 khi không thấy...).
  • Dữ liệu thường ở dạng JSON.

KHÁC: GraphQL (một endpoint, client chọn field cần), gRPC (nhị phân, hợp
giao tiếp nội bộ service).

MẸO: URL theo tài nguyên + đúng method + đúng status code = 80% của một
REST API tốt. Thêm versioning (/v1/) và phân trang (?page=&limit=) cho API
công khai. Quan trọng nhất là NHẤT QUÁN toàn API.',
'REST is an HTTP-based API design style: treat everything as a RESOURCE with
a URL, acted on via HTTP methods.

PRINCIPLES:
  • Resources are NOUNS, plural: /users, /users/42, /users/42/orders
  • Methods carry the action meaning (do NOT put verbs in the URL):
      GET    /users        list
      GET    /users/42     get one user
      POST   /users        create
      PUT    /users/42     replace whole
      PATCH  /users/42     partial update
      DELETE /users/42     remove
  ✗ /getUser?id=42 or /createUser    ✓ GET /users/42, POST /users
  • Stateless: the request carries all it needs (token); the server keeps no session.
  • Return correct status codes (201 on create, 404 when not found...).
  • Data is usually JSON.

OTHERS: GraphQL (one endpoint, the client picks fields), gRPC (binary, good
for internal service-to-service).

TIP: resource-based URLs + correct methods + correct status codes = 80% of a
good REST API. Add versioning (/v1/) and pagination (?page=&limit=) for public
APIs. Most important: be CONSISTENT across the whole API.',
'[]',680,320)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
