-- TOPIC AWS file 2: Data + Ops
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_aws_s3','S3 (Object Storage)','DevOps & Cloud',
'S3 (Simple Storage Service) là kho lưu trữ OBJECT (file) gần như vô hạn,
độ bền cực cao. Dùng cho ảnh, video, backup, file tĩnh, data lake.

KHÁI NIỆM:
  • Bucket: "thùng" chứa object, tên DUY NHẤT toàn cầu.
  • Object: file + metadata, định danh bằng KEY (đường dẫn ảo: photos/2025/a.jpg).
  • KHÔNG phải hệ thống file thật (không có thư mục thật, "thư mục" chỉ là
    tiền tố của key).

TÍNH NĂNG:
  • Storage class: Standard (nóng), Intelligent-Tiering, Glacier (lưu trữ
    lạnh, rẻ, lấy chậm) -> tiết kiệm theo tần suất truy cập.
  • Versioning; lifecycle (tự chuyển sang lớp rẻ / xóa sau N ngày).
  • Static website hosting; tích hợp CloudFront (CDN) để phân phối nhanh.
  • Bảo mật: mặc định PRIVATE; quản quyền bằng bucket policy/IAM; mã hóa at-rest.

DÙNG CHO: chứa asset/upload của web (thay vì lưu trên server), backup, log,
data lake, phân phối file tĩnh.

MẸO: đưa file tĩnh/upload lên S3 + CloudFront thay vì giữ trên EC2 -> rẻ,
bền, scale sẵn. CẨN THẬN cấu hình public — bucket mở gây rò rỉ dữ liệu là
sự cố kinh điển; mặc định để PRIVATE, mở có chủ đích.',
'S3 (Simple Storage Service) is near-infinite OBJECT (file) storage with
extremely high durability. Used for images, video, backups, static files,
data lakes.

CONCEPTS:
  • Bucket: a "container" for objects, with a globally UNIQUE name.
  • Object: a file + metadata, identified by a KEY (a virtual path: photos/2025/a.jpg).
  • NOT a real filesystem (no real folders; "folders" are just key prefixes).

FEATURES:
  • Storage classes: Standard (hot), Intelligent-Tiering, Glacier (cold, cheap,
    slow retrieval) -> save cost by access frequency.
  • Versioning; lifecycle (auto-move to cheaper class / delete after N days).
  • Static website hosting; integrates with CloudFront (CDN) for fast delivery.
  • Security: PRIVATE by default; permissions via bucket policy/IAM; at-rest encryption.

USED FOR: hosting web assets/uploads (instead of on a server), backups, logs,
data lakes, static file delivery.

TIP: put static files/uploads on S3 + CloudFront instead of keeping them on
EC2 -> cheap, durable, already scalable. BE CAREFUL with public config - an
open bucket leaking data is a classic incident; keep PRIVATE by default,
open deliberately.',
'[]',700,50),

('n_aws_rds','RDS (SQL quản lý)','DevOps & Cloud',
'RDS (Relational Database Service) là CSDL QUAN HỆ được QUẢN LÝ (MySQL,
PostgreSQL, MariaDB, SQL Server, Oracle, Aurora). AWS lo cài đặt, backup,
patch, nhân bản.

AWS LO GIÙM:
  • Cài đặt, vá lỗi, nâng cấp phiên bản.
  • Backup tự động + snapshot; point-in-time recovery.
  • Multi-AZ: bản standby ở AZ khác, tự chuyển đổi (failover) khi primary sập
    -> HA.
  • Read replica: bản sao CHỈ ĐỌC để chia tải đọc (scale read).

AURORA: DB tương thích MySQL/PostgreSQL do AWS xây, nhanh hơn & tự co giãn
lưu trữ; có Aurora Serverless (tự scale theo tải).

BẠN VẪN LO: thiết kế schema, index, tối ưu query, chọn instance size.

DÙNG CHO: dữ liệu quan hệ cần ACID, giao dịch (đơn hàng, người dùng, tài chính).

MẸO: production nên bật Multi-AZ (HA) + backup. Tải đọc lớn -> thêm read
replica. Không muốn tự quản MySQL trên EC2 -> dùng RDS. Đây là "DB trong
private subnet" điển hình. So với DynamoDB: RDS cho quan hệ/giao dịch phức
tạp; Dynamo cho quy mô key-value cực lớn.',
'RDS (Relational Database Service) is a MANAGED relational database (MySQL,
PostgreSQL, MariaDB, SQL Server, Oracle, Aurora). AWS handles setup, backups,
patching, replication.

AWS HANDLES:
  • Setup, patching, version upgrades.
  • Automated backups + snapshots; point-in-time recovery.
  • Multi-AZ: a standby in another AZ, auto-failover when the primary dies -> HA.
  • Read replicas: READ-only copies to spread read load (scale reads).

AURORA: an AWS-built MySQL/PostgreSQL-compatible DB, faster & auto-scaling
storage; Aurora Serverless auto-scales with load.

YOU STILL HANDLE: schema design, indexes, query tuning, instance sizing.

USED FOR: relational data needing ACID and transactions (orders, users, finance).

TIP: enable Multi-AZ (HA) + backups in production. Heavy read load -> add read
replicas. Do not want to self-manage MySQL on EC2 -> use RDS. This is the
typical "DB in a private subnet". Vs DynamoDB: RDS for complex
relations/transactions; Dynamo for very large key-value scale.',
'[]',740,90),

('n_aws_dynamodb','DynamoDB (NoSQL)','DevOps & Cloud',
'DynamoDB là CSDL NoSQL (key-value / document) được quản lý HOÀN TOÀN, độ
trễ mili-giây ở MỌI quy mô, tự scale. Serverless (không quản server DB).

MÔ HÌNH:
  • Table -> item (dòng) -> attribute; mỗi item định danh bằng PRIMARY KEY:
    - Partition key (băm để phân tán dữ liệu), tùy chọn thêm Sort key.
  • Không schema cứng (mỗi item có thể có thuộc tính khác nhau).
  • Truy vấn hiệu quả theo KEY; muốn query linh hoạt hơn cần index phụ (GSI).

ĐẶC ĐIỂM:
  • Hiệu năng ổn định ở quy mô cực lớn (triệu request/giây).
  • On-demand (trả theo request) hoặc provisioned capacity.
  • Tích hợp tốt với serverless (Lambda + DynamoDB).

KHÁC RDS:
  Dynamo (NoSQL): scale khủng, truy vấn theo key, KHÔNG JOIN phức tạp ->
    phải thiết kế mô hình dữ liệu theo TRUY VẤN (access pattern).
  RDS (SQL): quan hệ, JOIN, giao dịch phức tạp, truy vấn linh hoạt.

DÙNG CHO: session, giỏ hàng, IoT, bảng xếp hạng, dữ liệu quy mô lớn truy
cập theo key.

MẸO: chọn Dynamo khi cần scale cực lớn + mẫu truy vấn rõ theo key; chọn RDS
khi cần quan hệ/JOIN/giao dịch. Thiết kế Dynamo xuất phát từ ACCESS PATTERN
(khác hẳn tư duy chuẩn hóa của SQL).',
'DynamoDB is a FULLY managed NoSQL database (key-value / document) with
millisecond latency at ANY scale, auto-scaling. Serverless (no DB servers to
manage).

MODEL:
  • Table -> item (row) -> attribute; each item identified by a PRIMARY KEY:
    - a Partition key (hashed to distribute data), optionally a Sort key.
  • No rigid schema (items can have different attributes).
  • Efficient queries BY KEY; for more flexible queries you need secondary
    indexes (GSI).

CHARACTERISTICS:
  • Stable performance at enormous scale (millions of requests/second).
  • On-demand (pay per request) or provisioned capacity.
  • Integrates well with serverless (Lambda + DynamoDB).

VS RDS:
  Dynamo (NoSQL): massive scale, key-based queries, NO complex JOINs -> you
    must model data around the QUERIES (access patterns).
  RDS (SQL): relational, JOINs, complex transactions, flexible queries.

USED FOR: sessions, shopping carts, IoT, leaderboards, large-scale data
accessed by key.

TIP: choose Dynamo for very large scale + clear key-based access; choose RDS
for relations/JOINs/transactions. Dynamo design starts from ACCESS PATTERNS
(quite unlike SQL normalization thinking).',
'[]',700,110),

('n_aws_cache','ElastiCache (Redis)','DevOps & Cloud',
'ElastiCache là dịch vụ CACHE trong bộ nhớ được quản lý (Redis hoặc
Memcached) -> tăng tốc đọc, giảm tải DB.

VÌ SAO CACHE:
  Đọc DB tốn kém/lặp lại -> lưu kết quả trong RAM (Redis) -> lần sau trả
  trong micro/mili-giây.
  App -> (kiểm tra cache) -> hit? trả ngay : miss? query DB rồi lưu vào cache

REDIS vs MEMCACHED:
  • Redis: giàu tính năng (cấu trúc dữ liệu, pub/sub, persistence,
    replication, sorted set) -> phổ biến hơn.
  • Memcached: đơn giản, đa luồng, chỉ cache key-value thuần.

MẪU DÙNG:
  • Cache-aside: app tự kiểm tra cache trước, miss thì nạp từ DB rồi ghi cache.
  • Session store, rate limiting, leaderboard (Redis sorted set), hàng đợi nhẹ.

LƯU Ý: cache có thể CŨ (stale) -> đặt TTL + chiến lược vô hiệu hóa
(invalidation) khi dữ liệu đổi. Có câu đùa: "hai việc khó nhất là vô hiệu
cache và đặt tên biến".

MẸO: cache những thứ đọc-nhiều-ghi-ít (config, hồ sơ, kết quả tính nặng),
đặt TTL hợp lý. Redis là lựa chọn mặc định. Đây là cách rẻ & hiệu quả để
giảm tải RDS/DynamoDB và tăng tốc app.',
'ElastiCache is a managed in-memory CACHE service (Redis or Memcached) ->
faster reads, less DB load.

WHY CACHE:
  Expensive/repeated DB reads -> store the result in RAM (Redis) -> next time
  served in micro/milliseconds.
  App -> (check cache) -> hit? return now : miss? query DB then store in cache

REDIS vs MEMCACHED:
  • Redis: feature-rich (data structures, pub/sub, persistence, replication,
    sorted sets) -> more popular.
  • Memcached: simple, multi-threaded, plain key-value cache only.

USAGE PATTERNS:
  • Cache-aside: the app checks cache first, on a miss loads from DB and writes cache.
  • Session store, rate limiting, leaderboards (Redis sorted sets), light queues.

NOTE: caches can be STALE -> set a TTL + an invalidation strategy when data
changes. As the joke goes: "the two hardest things are cache invalidation and
naming things".

TIP: cache read-heavy, write-light things (config, profiles, heavy computed
results), with a sensible TTL. Redis is the default choice. This is a cheap,
effective way to offload RDS/DynamoDB and speed up the app.',
'[]',740,130),

-- ------------------------- OPS ------------------------------------
('n_aws_cloudfront','CloudFront (CDN)','DevOps & Cloud',
'CloudFront là CDN của AWS: phân phối nội dung từ edge location gần người
dùng (xem thêm node CDN chung ở topic Network). Tích hợp chặt với S3, ALB,
EC2 làm origin.

CÁCH DÙNG:
  Origin (S3 / ALB / EC2) -> CloudFront (cache ở hàng trăm edge) -> User
  • Cache asset tĩnh (ảnh, JS, CSS, video) gần user -> nhanh, giảm tải origin.
  • Hỗ trợ HTTPS (cert qua ACM miễn phí), HTTP/2, HTTP/3.
  • Cache behavior theo path (vd /static/* cache lâu, /api/* không cache).

TÍNH NĂNG:
  • Chống DDoS (kèm AWS Shield), WAF (lọc tấn công tầng 7).
  • Lambda@Edge / CloudFront Functions: chạy code ngay ở edge (rewrite, auth nhẹ).
  • Signed URL/cookie: giới hạn truy cập nội dung riêng tư.

MẪU KINH ĐIỂN: web tĩnh (React build) trên S3 + CloudFront -> nhanh, rẻ,
HTTPS, scale sẵn.

MẸO: đặt CloudFront trước S3 cho asset tĩnh và trước ALB cho web động ->
tăng tốc toàn cầu + giảm tải origin + thêm lớp bảo mật (Shield/WAF). Dùng
ACM để có chứng chỉ HTTPS miễn phí.',
'CloudFront is the AWS CDN: it delivers content from edge locations near users
(see the general CDN node in the Network topic). Integrates tightly with S3,
ALB, EC2 as origins.

HOW TO USE:
  Origin (S3 / ALB / EC2) -> CloudFront (cached at hundreds of edges) -> User
  • Cache static assets (images, JS, CSS, video) near users -> fast, offloads origin.
  • Supports HTTPS (free cert via ACM), HTTP/2, HTTP/3.
  • Cache behavior per path (e.g. /static/* cached long, /api/* not cached).

FEATURES:
  • DDoS protection (with AWS Shield), WAF (layer-7 attack filtering).
  • Lambda@Edge / CloudFront Functions: run code at the edge (rewrites, light auth).
  • Signed URLs/cookies: restrict access to private content.

CLASSIC PATTERN: a static site (React build) on S3 + CloudFront -> fast,
cheap, HTTPS, already scalable.

TIP: put CloudFront in front of S3 for static assets and in front of an ALB
for dynamic web -> global speedup + origin offload + a security layer
(Shield/WAF). Use ACM for a free HTTPS certificate.',
'[]',940,50),

('n_aws_route53','Route 53 (DNS)','DevOps & Cloud',
'Route 53 là dịch vụ DNS được quản lý của AWS (xem node DNS chung ở topic
Network), cộng thêm đăng ký domain và định tuyến thông minh + health check.

CHỨC NĂNG:
  • Hosted zone: quản lý bản ghi DNS cho domain (A, AAAA, CNAME, MX, TXT...).
  • Đăng ký / chuyển domain.
  • Alias record: trỏ domain gốc (example.com) tới tài nguyên AWS (ALB,
    CloudFront, S3) — miễn phí, tự cập nhật IP (khác CNAME thường, dùng được
    ở apex domain).

ROUTING POLICY (định tuyến thông minh):
  • Simple        : một bản ghi.
  • Weighted      : chia % lưu lượng (A/B testing, canary).
  • Latency-based : gửi user tới region GẦN nhất -> nhanh.
  • Failover      : kèm health check, tự chuyển sang site dự phòng khi site
    chính chết.
  • Geolocation   : theo vị trí địa lý của user.

MẸO: dùng Alias record (KHÔNG phải CNAME) để trỏ apex domain vào ALB/
CloudFront. Latency-based + health check + failover = định tuyến toàn cầu
HA. Route 53 + CloudFront + ALB là bộ khung phân phối chuẩn trên AWS.',
'Route 53 is the AWS managed DNS service (see the general DNS node in the
Network topic), plus domain registration and smart routing + health checks.

FEATURES:
  • Hosted zone: manages DNS records for a domain (A, AAAA, CNAME, MX, TXT...).
  • Domain registration / transfer.
  • Alias record: points an apex domain (example.com) to an AWS resource (ALB,
    CloudFront, S3) — free, auto-updates IPs (unlike a plain CNAME, and works
    at the apex domain).

ROUTING POLICIES (smart routing):
  • Simple        : a single record.
  • Weighted      : split traffic by % (A/B testing, canary).
  • Latency-based : send users to the NEAREST region -> faster.
  • Failover      : with health checks, auto-switch to a backup site when the
    primary dies.
  • Geolocation   : by the user geographic location.

TIP: use an Alias record (NOT a CNAME) to point an apex domain to an ALB/
CloudFront. Latency-based + health checks + failover = global HA routing.
Route 53 + CloudFront + ALB is the standard AWS delivery stack.',
'[]',980,90),

('n_aws_cloudwatch','CloudWatch (Giám sát)','DevOps & Cloud',
'CloudWatch là hệ GIÁM SÁT & QUAN SÁT (observability) của AWS: thu thập
metric, log, và cảnh báo cho hầu hết mọi dịch vụ.

BA PHẦN:
  • Metrics: số đo theo thời gian (CPU của EC2, số invocation Lambda, độ trễ
    ALB, kết nối RDS). Có sẵn cho hầu hết dịch vụ.
  • Logs   : gom log tập trung (CloudWatch Logs); app/Lambda đẩy log vào để
    tìm kiếm.
  • Alarms : đặt ngưỡng -> vượt thì báo (qua SNS -> email/Slack) hoặc kích
    hoạt auto-scaling.

CÔNG CỤ LIÊN QUAN:
  • Dashboards: bảng biểu đồ tổng hợp.
  • Alarm + ASG: CPU > 70% -> tự thêm EC2.
  • X-Ray: distributed tracing (lần theo request qua nhiều dịch vụ).
  • CloudTrail (KHÁC): ghi lại AI GỌI API gì (audit/bảo mật), không phải metric.

MẸO: đặt alarm cho các chỉ số sống còn (CPU, tỉ lệ lỗi 5xx, độ trễ, độ dài
hàng đợi) -> phát hiện sự cố sớm + tự động scale. Đẩy log ứng dụng vào
CloudWatch Logs để tra cứu. Phân biệt: CloudWatch = hiệu năng/log; CloudTrail
= nhật ký hành động API (audit).',
'CloudWatch is the AWS MONITORING & observability system: it collects metrics,
logs, and alerts for almost every service.

THREE PARTS:
  • Metrics: time-series measurements (EC2 CPU, Lambda invocations, ALB
    latency, RDS connections). Built in for most services.
  • Logs   : centralized log collection (CloudWatch Logs); apps/Lambda push
    logs in for searching.
  • Alarms : set a threshold -> alert on breach (via SNS -> email/Slack) or
    trigger auto-scaling.

RELATED TOOLS:
  • Dashboards: aggregated charts.
  • Alarm + ASG: CPU > 70% -> auto-add EC2.
  • X-Ray: distributed tracing (follow a request across services).
  • CloudTrail (DIFFERENT): records WHO CALLED which API (audit/security),
    not metrics.

TIP: set alarms on vital signals (CPU, 5xx error rate, latency, queue depth)
-> detect issues early + auto-scale. Push app logs into CloudWatch Logs for
lookups. Distinguish: CloudWatch = performance/logs; CloudTrail = an API
action audit log.',
'[]',1020,110),

('n_aws_messaging','SQS & SNS (Nhắn tin)','DevOps & Cloud',
'SQS và SNS là dịch vụ NHẮN TIN được quản lý, giúp TÁCH RỜI (decouple) các
thành phần -> chịu lỗi & co giãn tốt (nền của kiến trúc hướng sự kiện).

SQS (Simple Queue Service) — HÀNG ĐỢI (điểm-điểm):
  Producer -> [SQS queue] -> Consumer (kéo message về xử lý)
  • Message được GIỮ tới khi xử lý xong (at-least-once); consumer chậm/chết
    không làm mất việc.
  • Đệm tải đột biến (buffer): nhét vào queue, consumer xử lý theo nhịp của nó.
  • FIFO queue nếu cần đúng thứ tự + không trùng.

SNS (Simple Notification Service) — PUB/SUB (phát tán):
  Publisher -> [SNS topic] -> NHIỀU subscriber (SQS, Lambda, email, HTTP)
  • Một message -> nhiều nơi nhận cùng lúc (fan-out).

MẪU FAN-OUT KINH ĐIỂN: SNS topic -> nhiều SQS queue -> mỗi service xử lý độc lập.
KHÁC: EventBridge (bus sự kiện định tuyến theo luật), Kinesis (luồng dữ liệu
lớn/streaming).

MẸO: dùng SQS để đệm & xử lý NỀN (gửi email, xử lý ảnh) -> API trả nhanh,
worker xử lý sau. Dùng SNS khi một sự kiện cần nhiều nơi phản ứng. Đây là
cách "decouple" service giống message broker trong microservices.',
'SQS and SNS are managed MESSAGING services that DECOUPLE components -> better
fault tolerance & elasticity (the basis of event-driven architecture).

SQS (Simple Queue Service) - a QUEUE (point-to-point):
  Producer -> [SQS queue] -> Consumer (pulls messages to process)
  • Messages are KEPT until processed (at-least-once); a slow/dead consumer
    does not lose work.
  • Buffers load spikes: push into the queue, the consumer processes at its pace.
  • FIFO queue if you need strict order + no duplicates.

SNS (Simple Notification Service) - PUB/SUB (fan-out):
  Publisher -> [SNS topic] -> MANY subscribers (SQS, Lambda, email, HTTP)
  • One message -> received by many places at once (fan-out).

CLASSIC FAN-OUT PATTERN: an SNS topic -> multiple SQS queues -> each service
processes independently.
OTHERS: EventBridge (an event bus routing by rules), Kinesis (large-scale data
streaming).

TIP: use SQS to buffer & process in the BACKGROUND (send email, process
images) -> the API responds fast, workers handle it later. Use SNS when one
event needs many reactions. This "decouples" services like a message broker
in microservices.',
'[]',1060,90)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
