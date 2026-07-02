-- ĐÀO SÂU Microservices (đợt 3f): Intro, Boundaries, DB-per-service, Sync
UPDATE kg_nodes SET
description=
'Microservices = chia hệ thống lớn thành NHIỀU service nhỏ; mỗi service
tự chủ (own DB, own deploy), gói một nghiệp vụ, giao tiếp qua mạng
(HTTP/gRPC/message).

MONOLITH vs MICROSERVICES:
  Monolith                     Microservices
  ─────────────────────        ─────────────────────
  1 codebase, 1 deploy         nhiều service, deploy riêng
  1 DB dùng chung              mỗi service một DB riêng
  scale cả khối                scale từng service độc lập
  gọi hàm trong process        gọi qua mạng (chậm hơn, có thể lỗi)
  đơn giản khi nhỏ             phức tạp vận hành (network, monitor)

KHI NÀO NÊN DÙNG:
  ✓ team lớn, muốn deploy độc lập, các phần scale khác nhau rõ rệt.
  ✗ team nhỏ / sản phẩm mới -> BẮT ĐẦU BẰNG MONOLITH (đơn giản), tách
    service khi thật sự cần ("monolith first").

ĐÁNH ĐỔI CỐT LÕI: đổi độ phức tạp trong CODE lấy độ phức tạp VẬN HÀNH +
hệ phân tán (latency, lỗi một phần, nhất quán cuối cùng). Đừng chọn
microservices chỉ vì "nghe hiện đại".'
,description_en=
'Microservices = splitting a large system into MANY small services; each
is autonomous (own DB, own deploy), wraps one business capability, and
communicates over the network (HTTP/gRPC/message).

MONOLITH vs MICROSERVICES:
  Monolith                     Microservices
  ─────────────────────        ─────────────────────
  1 codebase, 1 deploy         many services, deployed separately
  1 shared DB                  one DB per service
  scale the whole block        scale each service independently
  in-process function calls    network calls (slower, can fail)
  simple while small           operationally complex (network, monitor)

WHEN TO USE:
  ✓ large team, wanting independent deploys, parts scaling very differently.
  ✗ small team / new product -> START WITH A MONOLITH (simpler), split
    into services only when truly needed ("monolith first").

CORE TRADE-OFF: you trade CODE complexity for OPERATIONAL complexity + a
distributed system (latency, partial failure, eventual consistency). Do
not pick microservices just because it "sounds modern".'
WHERE id='n_ms_intro';

UPDATE kg_nodes SET
description=
'Chia service THEO NGHIỆP VỤ (business capability / bounded context),
KHÔNG theo tầng kỹ thuật.

  ✗ SAI (theo tầng): ControllerSvc, RepositorySvc, DatabaseSvc
     -> mọi thay đổi nghiệp vụ phải sửa nhiều service (coupling cao).
  ✓ ĐÚNG (theo miền): OrderSvc, PaymentSvc, InventorySvc
     -> mỗi service sở hữu trọn một nghiệp vụ + dữ liệu của nó.

NGUYÊN TẮC (từ Domain-Driven Design):
  • Bounded context : mỗi service là một ranh giới mô hình rõ ràng;
    "Customer" trong Billing khác "Customer" trong Support.
  • High cohesion   : thứ hay thay đổi CÙNG NHAU nằm trong CÙNG service.
  • Loose coupling  : service ít phụ thuộc nhau; đổi bên trong không lan.

DẤU HIỆU CHIA SAI:
  - Một thay đổi nghiệp vụ phải sửa NHIỀU service cùng lúc.
  - Hai service liên tục gọi nhau đồng bộ theo vòng -> nên gộp lại.

Chia đúng ranh giới là quyết định KHÓ và quan trọng nhất của
microservices; chia sai -> "distributed monolith" (tệ hơn cả monolith).'
,description_en=
'Split services by BUSINESS CAPABILITY (bounded context), NOT by technical
layer.

  ✗ WRONG (by layer): ControllerSvc, RepositorySvc, DatabaseSvc
     -> every business change edits multiple services (high coupling).
  ✓ RIGHT (by domain): OrderSvc, PaymentSvc, InventorySvc
     -> each service fully owns one capability + its data.

PRINCIPLES (from Domain-Driven Design):
  • Bounded context : each service is a clear model boundary; a
    "Customer" in Billing differs from a "Customer" in Support.
  • High cohesion   : things that change TOGETHER live in the SAME service.
  • Loose coupling  : services barely depend on each other; internal
    changes do not ripple out.

SIGNS OF BAD BOUNDARIES:
  - One business change forces edits across MANY services at once.
  - Two services constantly call each other synchronously in a loop
    -> they should be merged.

Getting boundaries right is the HARDEST and most important decision in
microservices; getting it wrong -> a "distributed monolith" (worse than
a monolith).'
WHERE id='n_ms_boundaries';

UPDATE kg_nodes SET
description=
'Mỗi service SỞ HỮU DB riêng; service khác KHÔNG được chạm trực tiếp DB
đó -> phải đi qua API/event.

  OrderSvc ─► orders_db          PaymentSvc ─► payments_db
    (chỉ OrderSvc chạm orders_db)   (chỉ PaymentSvc chạm payments_db)

VÌ SAO:
  1. Tách rời (decoupling): đổi schema nội bộ không phá service khác.
  2. Chọn đúng công nghệ: service này Postgres, service kia Mongo/Redis.
  3. Scale và fail độc lập.

HỆ QUẢ (điểm khó):
  • KHÔNG JOIN xuyên service -> cần dữ liệu của service khác thì gọi API
    hoặc giữ bản sao cục bộ cập nhật qua event (data replication).
  • KHÔNG transaction ACID xuyên service -> dùng Saga + Outbox để đạt
    nhất quán CUỐI CÙNG.

  ✗ SAI: nhiều service cùng ghi vào MỘT bảng dùng chung
     -> coupling ngầm, không tách deploy được (distributed monolith).

Đây chính là điều PHÂN BIỆT microservices thật với một monolith bị chẻ nhỏ.'
,description_en=
'Each service OWNS its own DB; other services must NOT touch that DB
directly -> they must go through APIs/events.

  OrderSvc ─► orders_db          PaymentSvc ─► payments_db
    (only OrderSvc touches orders_db)   (only PaymentSvc touches payments_db)

WHY:
  1. Decoupling: internal schema changes do not break other services.
  2. Right tool per service: one uses Postgres, another Mongo/Redis.
  3. Independent scaling and failure.

CONSEQUENCES (the hard part):
  • NO cross-service JOINs -> to use another service data, call its API or
    keep a local copy updated via events (data replication).
  • NO ACID transactions across services -> use Saga + Outbox to reach
    EVENTUAL consistency.

  ✗ WRONG: multiple services writing to ONE shared table
     -> hidden coupling, deploys cannot be separated (distributed monolith).

This is exactly what DISTINGUISHES real microservices from a chopped-up
monolith.'
WHERE id='n_ms_db_per_service';

UPDATE kg_nodes SET
description=
'Giao tiếp ĐỒNG BỘ: caller gọi và CHỜ phản hồi ngay (request/response).

HAI LỰA CHỌN PHỔ BIẾN:
  • REST/HTTP + JSON        : phổ biến, dễ debug, hợp API công khai.
  • gRPC (HTTP/2 + protobuf): nhị phân, nhanh, có schema + streaming,
    hợp giao tiếp NỘI BỘ service-to-service.

VÍ DỤ gọi service khác (REST, có timeout):
  const res = await fetch("http://inventory/api/stock/42", {
    signal: AbortSignal.timeout(3000),   // LUÔN đặt timeout
  });
  if (!res.ok) throw new Error("inventory " + res.status);
  const stock = await res.json();

RỦI RO PHẢI XỬ LÝ:
  1. Latency cộng dồn: A -> B -> C, mỗi hop thêm độ trễ.
  2. Ghép chặt tạm thời (temporal coupling): B chết -> A cũng lỗi theo.
  3. Cascading failure -> cần timeout + retry + circuit breaker.

KHI NÀO DÙNG SYNC: cần kết quả NGAY để trả cho user (đọc dữ liệu, xác
thực). Việc nền/thông báo -> ưu tiên ASYNC (message) để giảm coupling.'
,description_en=
'SYNCHRONOUS communication: the caller calls and WAITS for an immediate
response (request/response).

TWO COMMON CHOICES:
  • REST/HTTP + JSON        : popular, easy to debug, good for public APIs.
  • gRPC (HTTP/2 + protobuf): binary, fast, has a schema + streaming,
    good for INTERNAL service-to-service calls.

EXAMPLE calling another service (REST, with a timeout):
  const res = await fetch("http://inventory/api/stock/42", {
    signal: AbortSignal.timeout(3000),   // ALWAYS set a timeout
  });
  if (!res.ok) throw new Error("inventory " + res.status);
  const stock = await res.json();

RISKS TO HANDLE:
  1. Additive latency: A -> B -> C, each hop adds delay.
  2. Temporal coupling: if B is down -> A fails too.
  3. Cascading failure -> needs timeout + retry + circuit breaker.

WHEN TO USE SYNC: you need the result IMMEDIATELY to return to the user
(reading data, authentication). Background work/notifications -> prefer
ASYNC (messaging) to reduce coupling.'
WHERE id='n_ms_sync';
