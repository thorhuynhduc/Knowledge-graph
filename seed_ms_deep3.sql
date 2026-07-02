-- ĐÀO SÂU Microservices (đợt 3g): Gateway, CQRS, Discovery, Observability
UPDATE kg_nodes SET
description=
'API Gateway = CỬA NGÕ duy nhất giữa client và cụm service bên trong.
Client chỉ gọi gateway; gateway định tuyến tới service phù hợp.

  Client ─► [ API Gateway ] ─┬─► OrderService
                             ├─► PaymentService
                             └─► UserService

GATEWAY LO CÁC VIỆC CẮT NGANG (cross-cutting):
  • Routing       : /orders/* -> OrderSvc, /users/* -> UserSvc
  • Auth          : xác thực JWT MỘT LẦN ở cửa, service bên trong tin tưởng
  • Rate limiting : chặn lạm dụng
  • Aggregation   : gộp nhiều lời gọi service thành 1 response cho client
  • TLS, CORS, log, cache tập trung

VÍ DỤ (Express làm gateway đơn giản):
  app.use("/orders", auth, proxy("http://order-svc"));
  app.use("/users",  auth, proxy("http://user-svc"));

LỢI ÍCH: client KHÔNG cần biết địa chỉ/số lượng service; đổi cấu trúc
bên trong không ảnh hưởng client. BFF (Backend-for-Frontend) là gateway
riêng cho từng loại client (web / mobile).

CẢNH BÁO: gateway dễ thành nút nghẽn / single point of failure -> chạy
nhiều bản và giữ nó MỎNG (chỉ điều phối, KHÔNG nhồi business logic).'
,description_en=
'An API Gateway = the single ENTRANCE between clients and the internal
service cluster. Clients only call the gateway; it routes to the right
service.

  Client ─► [ API Gateway ] ─┬─► OrderService
                             ├─► PaymentService
                             └─► UserService

THE GATEWAY HANDLES CROSS-CUTTING CONCERNS:
  • Routing       : /orders/* -> OrderSvc, /users/* -> UserSvc
  • Auth          : verify the JWT ONCE at the door; inner services trust it
  • Rate limiting : block abuse
  • Aggregation   : combine several service calls into one client response
  • TLS, CORS, logging, centralized cache

EXAMPLE (Express as a simple gateway):
  app.use("/orders", auth, proxy("http://order-svc"));
  app.use("/users",  auth, proxy("http://user-svc"));

BENEFITS: clients need NOT know the address/number of services; internal
restructuring does not affect them. A BFF (Backend-for-Frontend) is a
dedicated gateway per client type (web / mobile).

WARNING: the gateway easily becomes a bottleneck / single point of
failure -> run multiple instances and keep it THIN (routing only, NO
business logic).'
WHERE id='n_ms_gateway';

UPDATE kg_nodes SET
description=
'CQRS (Command Query Responsibility Segregation): tách MÔ HÌNH GHI
(command) khỏi MÔ HÌNH ĐỌC (query) — hai đường đi, thậm chí hai store.

  Ghi: Command ─► Domain model ─► write DB (chuẩn hóa, đảm bảo ràng buộc)
                      │ (event)
                      ▼
  Đọc: Query   ◄─ read model  ◄─ projection (phi chuẩn hóa, tối ưu đọc)

VÍ DỤ: web bán hàng ĐỌC gấp nhiều lần GHI.
  • Write side: đặt hàng -> validate + ghi bảng orders chuẩn hóa.
  • Read side : projection dựng sẵn bảng phẳng "order_summary" cho trang
    lịch sử đơn -> đọc 1 truy vấn, không JOIN nặng.

GIẢI THÍCH TỪNG BƯỚC:
  1. Command đổi trạng thái, KHÔNG trả dữ liệu đọc.
  2. Query chỉ đọc, KHÔNG đổi trạng thái.
  3. Read model được cập nhật qua event từ write side -> nhất quán
     CUỐI CÙNG (có độ trễ nhỏ).

DÙNG KHI: đọc/ghi mất cân đối lớn, hoặc read cần hình dạng khác hẳn
write. Thường đi cùng Event Sourcing.

ĐÁNH ĐỔI: thêm phức tạp + độ trễ đồng bộ read model -> ĐỪNG dùng cho
CRUD đơn giản.'
,description_en=
'CQRS (Command Query Responsibility Segregation): separate the WRITE
model (commands) from the READ model (queries) - two paths, even two stores.

  Write: Command ─► Domain model ─► write DB (normalized, enforces rules)
                        │ (event)
                        ▼
  Read:  Query   ◄─ read model  ◄─ projection (denormalized, read-optimized)

EXAMPLE: an e-commerce site READS far more than it WRITES.
  • Write side: place order -> validate + write a normalized orders table.
  • Read side : a projection prebuilds a flat "order_summary" table for
    the order-history page -> one query read, no heavy JOINs.

STEP BY STEP:
  1. A command changes state and does NOT return read data.
  2. A query only reads and does NOT change state.
  3. The read model is updated via events from the write side -> EVENTUAL
     consistency (small lag).

USE WHEN: read/write are highly imbalanced, or reads need a very
different shape than writes. Often paired with Event Sourcing.

TRADE-OFF: extra complexity + read-model sync lag -> do NOT use it for
simple CRUD.'
WHERE id='n_ms_cqrs';

UPDATE kg_nodes SET
description=
'Trong microservices, service scale lên/xuống liên tục -> IP/địa chỉ
THAY ĐỔI. Service discovery giúp tìm địa chỉ động thay vì hardcode.

  Service B khởi động ─► ĐĂNG KÝ vào registry (Consul / Eureka / etcd)
  Service A cần B      ─► HỎI registry -> nhận danh sách địa chỉ B đang sống

HAI KIỂU:
  • Client-side : A hỏi registry rồi tự chọn instance (tự load balance).
  • Server-side : A gọi một địa chỉ ổn định (load balancer / DNS ảo);
    hạ tầng lo định tuyến tới instance sống.

TRONG KUBERNETES (phổ biến nhất hiện nay):
  • Mỗi Service có DNS name ổn định: http://order-svc.default.svc
  • kube-proxy + Service tự cân bằng tải sang các Pod đang sống.
  • readiness probe loại Pod chưa/không sẵn sàng khỏi danh sách.
  -> app chỉ cần gọi TÊN service, K8s lo discovery + load balance.

CỐT LÕI: đừng hardcode IP; dùng tên logic + registry/DNS để hệ thống tự
thích ứng khi instance thay đổi.'
,description_en=
'In microservices, services scale up/down constantly -> IPs/addresses
CHANGE. Service discovery finds addresses dynamically instead of
hardcoding them.

  Service B starts ─► REGISTERS into a registry (Consul / Eureka / etcd)
  Service A needs B ─► ASKS the registry -> gets the list of live B addresses

TWO STYLES:
  • Client-side : A asks the registry then picks an instance (self load-balance).
  • Server-side : A calls one stable address (a load balancer / virtual DNS);
    the infrastructure routes to a live instance.

IN KUBERNETES (the most common today):
  • Each Service has a stable DNS name: http://order-svc.default.svc
  • kube-proxy + the Service load-balance across the live Pods.
  • a readiness probe removes not-ready Pods from the list.
  -> the app just calls the service NAME, K8s handles discovery + balancing.

KEY IDEA: never hardcode IPs; use logical names + a registry/DNS so the
system adapts as instances change.'
WHERE id='n_ms_discovery';

UPDATE kg_nodes SET
description=
'Hệ phân tán khó debug: một request đi qua NHIỀU service. Observability =
khả năng hiểu hệ thống đang làm gì từ dữ liệu nó phát ra. Ba trụ cột:

  1. LOGS    — sự kiện rời rạc. Nên structured (JSON) + có
     correlation/trace id để NỐI log của cùng một request qua các service.
  2. METRICS — số đo theo thời gian (RPS, latency p95, error rate, CPU).
     Prometheus thu thập, Grafana vẽ, cảnh báo khi vượt ngưỡng.
  3. TRACES  — dấu vết MỘT request xuyên nhiều service (distributed
     tracing): mỗi service tạo một span, nối theo trace id.

  Request ──[trace-id=abc]──► Gateway ─► OrderSvc ─► PaymentSvc
                                 span       span         span
     -> xem timeline: hop nào chậm, hop nào lỗi.

CÔNG CỤ: OpenTelemetry (chuẩn thu thập), Jaeger/Tempo (trace),
Prometheus + Grafana (metrics), ELK/Loki (logs).

THỰC HÀNH THEN CHỐT: truyền trace id qua MỌI hop (qua header) -> mới ghép
được bức tranh toàn cảnh. Không có observability, microservices gần như
không thể vận hành.'
,description_en=
'Distributed systems are hard to debug: one request passes through MANY
services. Observability = the ability to understand what the system is
doing from the data it emits. Three pillars:

  1. LOGS    — discrete events. Should be structured (JSON) + carry a
     correlation/trace id to LINK logs of the same request across services.
  2. METRICS — time-series measurements (RPS, p95 latency, error rate, CPU).
     Prometheus collects, Grafana visualizes, alerts fire on thresholds.
  3. TRACES  — the trail of ONE request across many services (distributed
     tracing): each service creates a span, joined by the trace id.

  Request ──[trace-id=abc]──► Gateway ─► OrderSvc ─► PaymentSvc
                                 span       span         span
     -> see the timeline: which hop is slow, which hop errored.

TOOLS: OpenTelemetry (collection standard), Jaeger/Tempo (traces),
Prometheus + Grafana (metrics), ELK/Loki (logs).

KEY PRACTICE: propagate the trace id through EVERY hop (via headers) -> only
then can you assemble the full picture. Without observability,
microservices are nearly impossible to operate.'
WHERE id='n_ms_observability';
