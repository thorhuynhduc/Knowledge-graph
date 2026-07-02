-- ===================================================================
--  TOPIC: Microservices (song ngữ VI + EN, sơ đồ + ví dụ)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_microservices.sql
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_ms','Microservices','System Design',
'Kiến trúc microservices: khái niệm & ranh giới (DDD), giao tiếp sync/async, API gateway, nhất quán dữ liệu phân tán (Saga, CQRS, Outbox), service discovery, resiliency và observability.',
'Microservices architecture: concepts & boundaries (DDD), sync/async communication, API gateway, distributed data consistency (Saga, CQRS, Outbox), service discovery, resiliency, and observability.',
'[]',1800,1650),

('s_ms_1','Khái niệm & Kiến trúc','System Design',
'Monolith vs microservices, chia ranh giới theo nghiệp vụ (DDD), database per service.',
'Monolith vs microservices, splitting by business boundaries (DDD), database per service.',
'[]',1720,1550),
('s_ms_2','Giao tiếp giữa service','System Design',
'Giao tiếp đồng bộ (REST/gRPC), bất đồng bộ (message/event) và API gateway.',
'Synchronous (REST/gRPC), asynchronous (message/event) communication, and the API gateway.',
'[]',1900,1550),
('s_ms_3','Dữ liệu & Nhất quán','System Design',
'Xử lý nhất quán phân tán: Saga, CQRS, Transactional Outbox.',
'Handling distributed consistency: Saga, CQRS, Transactional Outbox.',
'[]',1720,1780),
('s_ms_4','Vận hành & Resiliency','System Design',
'Service discovery, chống lỗi (circuit breaker/retry) và observability.',
'Service discovery, resiliency (circuit breaker/retry), and observability.',
'[]',1900,1780),

-- ===== Section 1 =====
('n_ms_intro','Monolith vs Microservices','System Design',
'Microservices = chia hệ thống thành nhiều service NHỎ, độc lập,
mỗi service phụ trách một nghiệp vụ và triển khai riêng.

  Monolith       : 1 codebase, 1 deploy, 1 DB dùng chung
  Microservices  : nhiều service, deploy độc lập, DB riêng mỗi service

Ưu điểm: mở rộng độc lập theo service, đội nhóm tự chủ, cô lập lỗi,
tự do chọn công nghệ theo service.

Nhược điểm: phức tạp vận hành (deploy, mạng, monitoring), độ trễ
mạng, nhất quán dữ liệu khó, cần DevOps/CI-CD mạnh.

Lời khuyên: đừng bắt đầu bằng microservices. Hãy làm một MODULAR
MONOLITH tốt trước, chỉ tách service khi có lý do rõ ràng (quy mô,
số đội nhóm, nhịp deploy khác nhau).',
'Microservices = splitting a system into many SMALL, independent
services, each owning one business capability and deployed
separately.

  Monolith       : 1 codebase, 1 deploy, 1 shared DB
  Microservices  : many services, independent deploys, a DB per service

Pros: independent scaling per service, autonomous teams, fault
isolation, freedom to pick tech per service.

Cons: operational complexity (deploy, network, monitoring), network
latency, hard data consistency, needs strong DevOps/CI-CD.

Advice: do not start with microservices. Build a good MODULAR
MONOLITH first, and split into services only for clear reasons
(scale, number of teams, differing deploy cadence).',
'[]',1680,1490),

('n_ms_boundaries','Ranh giới service (DDD)','System Design',
'Ranh giới service nên theo NGHIỆP VỤ (business capability), KHÔNG
theo tầng kỹ thuật. Domain-Driven Design gọi mỗi vùng là một
bounded context.

  ✓ ĐÚNG : Order Service, Payment Service, Inventory Service
  ✗ SAI  : Controller Service, Database Service (chia theo kỹ thuật)

Mỗi service phải TỰ CHỨA dữ liệu + logic của miền đó và chỉ giao
tiếp qua API/hợp đồng rõ ràng.

Chia sai ranh giới -> các service phụ thuộc chằng chịt, phải deploy
cùng nhau -> "distributed monolith": mang mọi cái khó của phân tán
mà không có lợi ích độc lập. Đây là sai lầm phổ biến nhất.',
'Service boundaries should follow BUSINESS capabilities, NOT
technical layers. Domain-Driven Design calls each area a bounded
context.

  ✓ RIGHT : Order Service, Payment Service, Inventory Service
  ✗ WRONG : Controller Service, Database Service (split by tech)

Each service must be SELF-CONTAINED with its domain data + logic and
communicate only via clear APIs/contracts.

Wrong boundaries -> tightly entangled services that must deploy
together -> a "distributed monolith": all the pain of distribution
with none of the independence benefits. This is the most common
mistake.',
'[]',1760,1490),

('n_ms_db_per_service','Database per Service','System Design',
'Mỗi service SỞ HỮU database riêng; service khác KHÔNG được truy cập
trực tiếp DB đó -> chỉ qua API của service chủ. Giữ tính độc lập và
đóng gói.

  Order Service    -> orders_db
  Payment Service  -> payments_db
  Inventory Service-> inventory_db

HỆ QUẢ quan trọng:
  • Không JOIN xuyên service -> muốn dữ liệu tổng hợp phải gọi API
    hoặc giữ một bản sao (read model / data replication).
  • Không có transaction ACID xuyên nhiều DB -> cần Saga cho quy
    trình nghiệp vụ trải nhiều service.

Đánh đổi độc lập lấy sự phức tạp về dữ liệu — đây là gốc rễ của hầu
hết thách thức trong microservices.',
'Each service OWNS its own database; other services must NOT access
that DB directly -> only through the owning service API. This keeps
independence and encapsulation.

  Order Service     -> orders_db
  Payment Service   -> payments_db
  Inventory Service -> inventory_db

Key CONSEQUENCES:
  • No cross-service JOINs -> to get combined data you call an API
    or keep a copy (a read model / data replication).
  • No ACID transaction across multiple DBs -> you need a Saga for a
    business process spanning several services.

You trade independence for data complexity - this is the root of
most microservices challenges.',
'[]',1680,1610),

-- ===== Section 2: Communication =====
('n_ms_sync','Giao tiếp đồng bộ (REST / gRPC)','System Design',
'Service gọi trực tiếp một service khác và CHỜ phản hồi.

  REST/HTTP : phổ biến, dễ, JSON; hợp API công khai và đa số nội bộ.
  gRPC      : nhị phân (protobuf), nhanh + gọn, có streaming; hợp
              giao tiếp nội bộ service-to-service hiệu năng cao.

Nhược điểm cốt lõi: TEMPORAL COUPLING (ghép nối thời gian) — service
đích phải đang sống thì lời gọi mới thành công. Một service chậm/sập
có thể kéo theo dây chuyền.

Vì vậy giao tiếp sync PHẢI đi kèm: timeout, retry + backoff, và
circuit breaker (xem node Resiliency).

Dùng khi: cần phản hồi ngay lập tức (truy vấn dữ liệu, xác thực).',
'A service calls another directly and WAITS for the response.

  REST/HTTP : popular, easy, JSON; good for public APIs and most
              internal calls.
  gRPC      : binary (protobuf), fast + compact, supports streaming;
              good for high-performance internal service-to-service.

The core drawback: TEMPORAL COUPLING - the target service must be
alive for the call to succeed. One slow/down service can cascade.

So synchronous calls MUST include: timeouts, retry + backoff, and a
circuit breaker (see the Resiliency node).

Use when: you need an immediate response (data queries, auth).',
'[]',1860,1490),

('n_ms_async','Giao tiếp bất đồng bộ (Message / Event)','System Design',
'Service giao tiếp qua MESSAGE BROKER, không chờ nhau trực tiếp ->
giảm ghép nối, chịu lỗi tốt hơn.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

Hai kiểu:
  • Message queue (điểm-điểm): mỗi message tới ĐÚNG một consumer
    (giao việc, xử lý nền — vd gửi email, resize ảnh).
  • Pub/Sub event: một event, NHIỀU service cùng phản ứng (vd
    "OrderPlaced" -> Inventory, Email, Analytics đều nghe).

Ưu: service đích tạm sập vẫn nhận message sau (broker giữ lại);
tách rời -> dễ thêm consumer mới.

Nhược: nhất quán cuối cùng (eventual), khó lần theo luồng, cần xử lý
message trùng (idempotent). Nền của event-driven architecture.',
'Services communicate through a MESSAGE BROKER, not directly waiting
on each other -> less coupling, better fault tolerance.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

Two styles:
  • Message queue (point-to-point): each message goes to EXACTLY one
    consumer (task handoff, background work - e.g. send email, resize
    image).
  • Pub/Sub event: one event, MANY services react (e.g. "OrderPlaced"
    -> Inventory, Email, Analytics all listen).

Pros: a down target still receives messages later (the broker keeps
them); decoupled -> easy to add new consumers.

Cons: eventual consistency, harder to trace flows, must handle
duplicate messages (be idempotent). The basis of event-driven
architecture.',
'[]',1940,1490),

('n_ms_gateway','API Gateway','System Design',
'API Gateway là CỬA VÀO duy nhất cho client bên ngoài, đứng trước
các microservice.

  Client ─► API Gateway ─► (routing) ─► Order / Payment / User ...

Nhiệm vụ tập trung một chỗ:
  • Định tuyến request tới đúng service
  • Xác thực & ủy quyền (kiểm JWT một lần)
  • Rate limiting, TLS termination
  • Aggregation: gộp nhiều service thành 1 phản hồi cho client
  • Che giấu cấu trúc nội bộ (client không gọi thẳng từng service)

Ví dụ: Kong, NGINX, AWS API Gateway. Với BFF (Backend For Frontend)
mỗi loại client có gateway riêng.

Cẩn thận: đừng nhồi business logic vào gateway -> dễ thành điểm
nghẽn và "God object".',
'An API Gateway is the single ENTRY POINT for external clients,
sitting in front of the microservices.

  Client ─► API Gateway ─► (routing) ─► Order / Payment / User ...

Responsibilities centralized in one place:
  • Route requests to the right service
  • Authentication & authorization (verify JWT once)
  • Rate limiting, TLS termination
  • Aggregation: combine several services into one client response
  • Hide the internal structure (clients do not call services directly)

Examples: Kong, NGINX, AWS API Gateway. With BFF (Backend For
Frontend), each client type gets its own gateway.

Caution: do not stuff business logic into the gateway -> it easily
becomes a bottleneck and a "God object".',
'[]',1860,1610),

-- ===== Section 3: Data & Consistency =====
('n_ms_saga','Saga — nhất quán phân tán','System Design',
'Vì không có transaction ACID xuyên nhiều DB service, Saga = một
CHUỖI transaction cục bộ; mỗi bước phát event kích hoạt bước kế.
Nếu một bước LỖI -> chạy các bước BÙ TRỪ (compensating) để hoàn tác
các bước trước.

SƠ ĐỒ (quy trình đặt hàng):

  Order created
    │
    ├─► Payment: charge      ── lỗi ─► Cancel Order        (bù)
    │
    ├─► Inventory: reserve   ── lỗi ─► Refund Payment       (bù)
    │
    └─► Shipping: create     ── lỗi ─► Release Inventory    (bù)

Hai kiểu điều phối:
  • Choreography : mỗi service tự lắng nghe event của service khác,
    KHÔNG có bộ điều khiển trung tâm (đơn giản, dễ rối khi nhiều bước).
  • Orchestration: một orchestrator điều khiển trình tự (dễ theo dõi,
    tập trung hơn).

Đánh đổi: chỉ đạt nhất quán CUỐI CÙNG; phải thiết kế cẩn thận bước bù
và xử lý lỗi bù.',
'Because there is no ACID transaction across multiple service DBs, a
Saga = a SEQUENCE of local transactions; each step emits an event
triggering the next. If a step FAILS -> run COMPENSATING steps to
undo the previous ones.

DIAGRAM (order placement):

  Order created
    │
    ├─► Payment: charge      ── fail ─► Cancel Order         (compensate)
    │
    ├─► Inventory: reserve   ── fail ─► Refund Payment        (compensate)
    │
    └─► Shipping: create     ── fail ─► Release Inventory     (compensate)

Two coordination styles:
  • Choreography : each service listens to others events, with NO
    central controller (simple, but tangled with many steps).
  • Orchestration: a single orchestrator drives the sequence (easier
    to follow, more centralized).

Trade-off: only EVENTUAL consistency; you must carefully design
compensating steps and handle compensation failures.',
'[]',1680,1720),

('n_ms_cqrs','CQRS','System Design',
'CQRS (Command Query Responsibility Segregation): tách mô hình GHI
(command) khỏi mô hình ĐỌC (query).

  Ghi (Command) : mô hình chuẩn hóa, đảm bảo bất biến nghiệp vụ.
  Đọc (Query)   : mô hình phi chuẩn hóa, tối ưu cho truy vấn hiển
                  thị (read model), có thể ở DB/khoản mục khác.

Thường đi kèm event: khi ghi thành công -> phát event -> cập nhật
read model (bất đồng bộ).

  [Command] -> write DB -> event -> cập nhật -> [Read model] -> [Query]

Hợp khi: tỉ lệ đọc >> ghi, hoặc mô hình đọc và ghi khác nhau nhiều.

Nhược: phức tạp thêm, và read model trễ so với write (eventual
consistency). Đừng dùng CQRS cho CRUD đơn giản.',
'CQRS (Command Query Responsibility Segregation): separate the WRITE
model (command) from the READ model (query).

  Write (Command) : a normalized model enforcing business invariants.
  Read (Query)    : a denormalized model optimized for display
                    queries (a read model), possibly in a different DB.

Often paired with events: on a successful write -> emit an event ->
update the read model (asynchronously).

  [Command] -> write DB -> event -> update -> [Read model] -> [Query]

Use when: reads >> writes, or the read and write models differ a lot.

Cons: added complexity, and the read model lags the write (eventual
consistency). Do not use CQRS for simple CRUD.',
'[]',1760,1720),

('n_ms_outbox','Transactional Outbox','System Design',
'Vấn đề "dual write": một thao tác cần GHI DB và PHÁT message. Nếu
ghi DB xong rồi gửi message bị lỗi (hoặc ngược lại) -> hai bên lệch
nhau, mất event.

Giải pháp Outbox: ghi bản ghi nghiệp vụ VÀ một dòng "outbox" trong
CÙNG một transaction DB (nguyên tử). Một tiến trình relay đọc bảng
outbox rồi phát message, đánh dấu đã gửi.

  BEGIN;
    INSERT INTO orders (...);
    INSERT INTO outbox (event_type, payload);   -- cùng transaction
  COMMIT;
  -- relay: đọc outbox chưa gửi -> publish lên broker -> đánh dấu sent

Đảm bảo giao ÍT NHẤT MỘT LẦN (at-least-once) -> consumer PHẢI
idempotent (xử lý trùng không gây hại). Là cách chuẩn để ghép DB và
messaging đáng tin cậy.',
'The "dual write" problem: an operation must WRITE to the DB and
PUBLISH a message. If the DB write succeeds but the publish fails
(or vice versa) -> the two diverge and events are lost.

Outbox solution: write the business record AND an "outbox" row in
the SAME DB transaction (atomic). A relay process reads the outbox
table, publishes the message, then marks it sent.

  BEGIN;
    INSERT INTO orders (...);
    INSERT INTO outbox (event_type, payload);   -- same transaction
  COMMIT;
  -- relay: read unsent outbox -> publish to the broker -> mark sent

It guarantees AT-LEAST-ONCE delivery -> consumers MUST be idempotent
(handling duplicates does no harm). This is the standard way to
combine DB writes and messaging reliably.',
'[]',1680,1780),

-- ===== Section 4: Operations & Resiliency =====
('n_ms_discovery','Service Discovery','System Design',
'Service scale động, container lên/xuống liên tục -> IP thay đổi ->
cần cơ chế tìm địa chỉ hiện tại của một service.

  • Client-side discovery : client hỏi một registry (Consul, Eureka)
    lấy danh sách instance rồi tự chọn (client tự cân bằng tải).
  • Server-side discovery  : client gọi một địa chỉ ổn định; load
    balancer/DNS định tuyến tới instance (vd Kubernetes Service).

Trong Kubernetes: mỗi service có DNS nội bộ ổn định
(order-svc.namespace.svc) + cân bằng tải tích hợp -> thường KHÔNG
cần registry riêng.

Đi kèm health check: chỉ định tuyến tới instance đang khỏe.',
'Services scale dynamically, containers come and go -> IPs change ->
you need a way to find a service current address.

  • Client-side discovery : the client queries a registry (Consul,
    Eureka) for the instance list and picks one (client load-balances).
  • Server-side discovery  : the client calls a stable address; a
    load balancer/DNS routes to an instance (e.g. Kubernetes Service).

In Kubernetes: each service has a stable internal DNS name
(order-svc.namespace.svc) + built-in load balancing -> usually NO
separate registry needed.

Pair it with health checks: route only to healthy instances.',
'[]',1860,1720),

('n_ms_circuit','Resiliency: Circuit Breaker, Retry, Timeout','System Design',
'Trong hệ phân tán, lỗi mạng là BÌNH THƯỜNG -> phải chống lỗi lan
truyền (cascading failure) làm sập cả hệ.

  • Timeout        : luôn đặt; đừng chờ vô hạn một service chậm.
  • Retry + backoff: thử lại với độ trễ TĂNG DẦN + jitter (cẩn thận
    retry storm làm ngập service đang yếu).
  • Circuit breaker: khi service đích lỗi liên tục -> "mở mạch", trả
    lỗi/nhanh fallback một thời gian thay vì cứ gọi -> cho đích hồi
    phục. Trạng thái:
        closed (gọi bình thường) -> open (chặn, trả lỗi ngay)
        -> half-open (thử vài lời gọi) -> closed nếu ổn
  • Bulkhead       : cô lập tài nguyên (pool riêng) để một phần lỗi
    không kéo sập toàn bộ.

Thư viện: opossum (Node.js), resilience4j (Java).',
'In a distributed system, network failures are NORMAL -> you must
prevent cascading failures from taking down the whole system.

  • Timeout        : always set one; never wait forever on a slow
    service.
  • Retry + backoff: retry with INCREASING delay + jitter (beware a
    retry storm flooding an already weak service).
  • Circuit breaker: when a target keeps failing -> "open the
    circuit", return a fast error/fallback for a while instead of
    calling -> let the target recover. States:
        closed (normal calls) -> open (blocked, fail fast)
        -> half-open (try a few calls) -> closed if healthy
  • Bulkhead       : isolate resources (separate pools) so one
    failing part does not sink everything.

Libraries: opossum (Node.js), resilience4j (Java).',
'[]',1940,1720),

('n_ms_observability','Observability','System Design',
'Với nhiều service, một request đi qua nhiều nơi -> rất khó lần theo
khi có sự cố. Observability đứng trên 3 trụ cột:

  • Logs    : log có CẤU TRÚC (JSON) + correlation id xuyên service
    để nối các dòng log của cùng một request.
  • Metrics : số liệu định lượng (Prometheus) -> dashboard (Grafana),
    cảnh báo (alert) khi vượt ngưỡng.
  • Tracing : distributed tracing (OpenTelemetry, Jaeger) — theo dõi
    MỘT request qua tất cả service, thấy từng chặng tốn bao lâu.

SƠ ĐỒ trace:
  request ─trace-id=abc─► Gateway ─► Order ─► Payment ─► DB
           (mỗi chặng là 1 span, cùng trace-id)

Truyền trace id qua header giữa các service (context propagation).
Thiếu observability = vận hành microservices trong bóng tối.',
'With many services, one request passes through many places -> very
hard to trace during an incident. Observability rests on 3 pillars:

  • Logs    : STRUCTURED logs (JSON) + a correlation id across
    services to stitch together the log lines of one request.
  • Metrics : quantitative measurements (Prometheus) -> dashboards
    (Grafana), alerts when thresholds are crossed.
  • Tracing : distributed tracing (OpenTelemetry, Jaeger) - follow
    ONE request across all services, seeing how long each hop takes.

Trace DIAGRAM:
  request ─trace-id=abc─► Gateway ─► Order ─► Payment ─► DB
           (each hop is a span, same trace-id)

Propagate the trace id via headers between services (context
propagation). Without observability you operate microservices in the
dark.',
'[]',1860,1780)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_ms_part-of','root','t_ms','part-of'),
('e_t_ms_s_ms_1_part-of','t_ms','s_ms_1','part-of'),
('e_t_ms_s_ms_2_part-of','t_ms','s_ms_2','part-of'),
('e_t_ms_s_ms_3_part-of','t_ms','s_ms_3','part-of'),
('e_t_ms_s_ms_4_part-of','t_ms','s_ms_4','part-of'),
('e_s_ms_1_n_ms_intro','s_ms_1','n_ms_intro','part-of'),
('e_s_ms_1_n_ms_boundaries','s_ms_1','n_ms_boundaries','part-of'),
('e_s_ms_1_n_ms_db_per_service','s_ms_1','n_ms_db_per_service','part-of'),
('e_s_ms_2_n_ms_sync','s_ms_2','n_ms_sync','part-of'),
('e_s_ms_2_n_ms_async','s_ms_2','n_ms_async','part-of'),
('e_s_ms_2_n_ms_gateway','s_ms_2','n_ms_gateway','part-of'),
('e_s_ms_3_n_ms_saga','s_ms_3','n_ms_saga','part-of'),
('e_s_ms_3_n_ms_cqrs','s_ms_3','n_ms_cqrs','part-of'),
('e_s_ms_3_n_ms_outbox','s_ms_3','n_ms_outbox','part-of'),
('e_s_ms_4_n_ms_discovery','s_ms_4','n_ms_discovery','part-of'),
('e_s_ms_4_n_ms_circuit','s_ms_4','n_ms_circuit','part-of'),
('e_s_ms_4_n_ms_observability','s_ms_4','n_ms_observability','part-of'),
('e_n_ms_db_per_service_n_ms_saga_rel','n_ms_db_per_service','n_ms_saga','related'),
('e_n_ms_async_n_ms_outbox_rel','n_ms_async','n_ms_outbox','related'),
('e_t_ms_q_43_related','t_ms','q_43','related'),
('e_t_ms_q_10_related','t_ms','q_10','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
