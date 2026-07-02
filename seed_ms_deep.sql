-- ĐÀO SÂU Microservices (đợt 3e): Saga, Outbox, Async, Circuit breaker
UPDATE kg_nodes SET
description=
'Không có transaction ACID xuyên nhiều DB service. Saga = chuỗi
transaction cục bộ; mỗi bước phát event; nếu một bước LỖI -> chạy bước
BÙ TRỪ (compensating) để hoàn tác các bước trước.

SƠ ĐỒ (đặt hàng):
  Order created
    ├─► Payment: charge      ── lỗi ─► Cancel Order       (bù)
    ├─► Inventory: reserve   ── lỗi ─► Refund Payment      (bù)
    └─► Shipping: create     ── lỗi ─► Release Inventory   (bù)

VÍ DỤ ORCHESTRATION (mã giả — chạy bù theo thứ tự NGƯỢC):
  async function placeOrderSaga(order) {
    const done = [];
    try {
      await payment.charge(order);     done.push("payment");
      await inventory.reserve(order);  done.push("inventory");
      await shipping.create(order);    done.push("shipping");
    } catch (e) {
      if (done.includes("inventory")) await inventory.release(order);
      if (done.includes("payment"))   await payment.refund(order);
      throw e;   // saga thất bại nhưng đã hoàn tác sạch
    }
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi bước là transaction cục bộ ở một service (DB riêng).
  2. Lỗi ở bước n -> hoàn tác n-1 ... 1 bằng hành động bù.
  3. Bù phải IDEMPOTENT (chạy lại không hại) vì có thể bị retry.

HAI KIỂU ĐIỀU PHỐI:
  • Choreography  : service tự nghe event của nhau, KHÔNG trung tâm
    (đơn giản, dễ rối khi nhiều bước).
  • Orchestration : một orchestrator điều khiển trình tự (dễ theo dõi).

Đánh đổi: chỉ nhất quán CUỐI CÙNG; phải thiết kế kỹ các bước bù.'
,description_en=
'There is no ACID transaction across multiple service DBs. A Saga = a
sequence of local transactions; each step emits an event; if a step
FAILS -> run COMPENSATING steps to undo the previous ones.

DIAGRAM (order placement):
  Order created
    ├─► Payment: charge      ── fail ─► Cancel Order        (compensate)
    ├─► Inventory: reserve   ── fail ─► Refund Payment        (compensate)
    └─► Shipping: create     ── fail ─► Release Inventory     (compensate)

ORCHESTRATION EXAMPLE (pseudo-code - compensate in REVERSE order):
  async function placeOrderSaga(order) {
    const done = [];
    try {
      await payment.charge(order);     done.push("payment");
      await inventory.reserve(order);  done.push("inventory");
      await shipping.create(order);    done.push("shipping");
    } catch (e) {
      if (done.includes("inventory")) await inventory.release(order);
      if (done.includes("payment"))   await payment.refund(order);
      throw e;   // saga failed but rolled back cleanly
    }
  }

STEP BY STEP:
  1. Each step is a local transaction in one service (its own DB).
  2. A failure at step n -> undo n-1 ... 1 via compensating actions.
  3. Compensation must be IDEMPOTENT (harmless to re-run) since it may retry.

TWO COORDINATION STYLES:
  • Choreography  : services listen to each other events, NO central
    controller (simple, tangled with many steps).
  • Orchestration : a single orchestrator drives the sequence (easy to follow).

Trade-off: only EVENTUAL consistency; design compensating steps carefully.'
WHERE id='n_ms_saga';

UPDATE kg_nodes SET
description=
'Vấn đề DUAL WRITE: một thao tác cần GHI DB và PHÁT message. Nếu ghi DB
xong nhưng gửi message lỗi (hoặc ngược lại) -> hai bên lệch nhau, mất event.

GIẢI PHÁP OUTBOX: ghi bản ghi nghiệp vụ VÀ một dòng outbox trong CÙNG
một transaction DB (nguyên tử). Một tiến trình relay đọc outbox rồi phát.

BƯỚC 1 — ghi nguyên tử (cùng transaction):
  BEGIN;
    INSERT INTO orders (id, ...) VALUES (...);
    INSERT INTO outbox (id, topic, payload, sent)
      VALUES (gen_random_uuid(), ''order.created'', ''{...}'', false);
  COMMIT;

BƯỚC 2 — relay (worker riêng) đọc & phát:
  const rows = await db.query(
    "SELECT * FROM outbox WHERE sent=false ORDER BY created_at LIMIT 100");
  for (const r of rows) {
    await broker.publish(r.topic, r.payload);            // phát message
    await db.query("UPDATE outbox SET sent=true WHERE id=$1", [r.id]);
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Ghi orders + outbox CÙNG transaction -> KHÔNG bao giờ lệch nhau.
  2. Relay đảm bảo giao ÍT NHẤT MỘT LẦN (at-least-once).
  3. Vì có thể gửi TRÙNG -> consumer phải IDEMPOTENT (khử trùng theo
     message id đã xử lý).

Đây là cách chuẩn để ghép DB + messaging đáng tin cậy (thay cho dual write).'
,description_en=
'The DUAL WRITE problem: an operation must WRITE to the DB and PUBLISH a
message. If the DB write succeeds but the publish fails (or vice versa)
-> the two diverge and events are lost.

OUTBOX SOLUTION: write the business record AND an outbox row in the SAME
DB transaction (atomic). A relay process reads the outbox then publishes.

STEP 1 - atomic write (same transaction):
  BEGIN;
    INSERT INTO orders (id, ...) VALUES (...);
    INSERT INTO outbox (id, topic, payload, sent)
      VALUES (gen_random_uuid(), ''order.created'', ''{...}'', false);
  COMMIT;

STEP 2 - a relay (separate worker) reads & publishes:
  const rows = await db.query(
    "SELECT * FROM outbox WHERE sent=false ORDER BY created_at LIMIT 100");
  for (const r of rows) {
    await broker.publish(r.topic, r.payload);            // publish
    await db.query("UPDATE outbox SET sent=true WHERE id=$1", [r.id]);
  }

STEP BY STEP:
  1. Writing orders + outbox in the SAME transaction -> they never diverge.
  2. The relay guarantees AT-LEAST-ONCE delivery.
  3. Because it may publish DUPLICATES -> consumers must be IDEMPOTENT
     (dedupe by processed message id).

This is the standard way to combine DB + messaging reliably (instead of
dual write).'
WHERE id='n_ms_outbox';

UPDATE kg_nodes SET
description=
'Service giao tiếp qua MESSAGE BROKER, không chờ nhau trực tiếp -> giảm
ghép nối, chịu lỗi tốt hơn.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

VÍ DỤ (RabbitMQ, amqplib):
  // Producer
  const ch = await conn.createChannel();
  await ch.assertQueue("order.created");
  ch.sendToQueue("order.created", Buffer.from(JSON.stringify(order)));

  // Consumer
  await ch.consume("order.created", (msg) => {
    const order = JSON.parse(msg.content.toString());
    sendEmail(order);
    ch.ack(msg);            // xác nhận đã xử lý xong
  });

HAI KIỂU:
  • Message queue (điểm-điểm): mỗi message tới ĐÚNG một consumer
    (giao việc nền: gửi email, resize ảnh).
  • Pub/Sub event: một event, NHIỀU service cùng nghe (OrderPlaced ->
    Inventory, Email, Analytics đều phản ứng).

GIẢI THÍCH TỪNG BƯỚC:
  1. Producer chỉ gửi rồi đi tiếp (KHÔNG chờ consumer).
  2. Consumer sập tạm -> broker GIỮ message, xử lý sau khi sống lại.
  3. ack sau khi xử lý xong; lỗi -> nack/requeue để thử lại.

ĐÁNH ĐỔI: nhất quán cuối cùng, khó lần luồng, cần idempotent (message có
thể giao trùng). Nền của event-driven architecture.'
,description_en=
'Services communicate through a MESSAGE BROKER, not directly waiting on
each other -> less coupling, better fault tolerance.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

EXAMPLE (RabbitMQ, amqplib):
  // Producer
  const ch = await conn.createChannel();
  await ch.assertQueue("order.created");
  ch.sendToQueue("order.created", Buffer.from(JSON.stringify(order)));

  // Consumer
  await ch.consume("order.created", (msg) => {
    const order = JSON.parse(msg.content.toString());
    sendEmail(order);
    ch.ack(msg);            // acknowledge it is fully processed
  });

TWO STYLES:
  • Message queue (point-to-point): each message goes to EXACTLY one
    consumer (background work: send email, resize image).
  • Pub/Sub event: one event, MANY services listen (OrderPlaced ->
    Inventory, Email, Analytics all react).

STEP BY STEP:
  1. The producer just sends and moves on (does NOT wait for consumers).
  2. A temporarily-down consumer -> the broker KEEPS the message, processed
     after it recovers.
  3. ack after processing; on error -> nack/requeue to retry.

TRADE-OFF: eventual consistency, harder to trace, needs idempotency
(messages may be delivered twice). The basis of event-driven architecture.'
WHERE id='n_ms_async';

UPDATE kg_nodes SET
description=
'Trong hệ phân tán, lỗi mạng là BÌNH THƯỜNG -> phải chống lỗi lan
truyền (cascading failure) làm sập cả hệ.

CÁC KỸ THUẬT:
  • Timeout         : luôn đặt, đừng chờ vô hạn service chậm.
  • Retry + backoff : thử lại với độ trễ TĂNG DẦN + jitter (tránh
    retry storm làm ngập service đang yếu).
  • Circuit breaker : đích lỗi liên tục -> "mở mạch", trả lỗi/fallback
    nhanh một thời gian -> cho đích hồi phục.
  • Bulkhead        : cô lập tài nguyên (pool riêng) để một phần lỗi
    không kéo sập toàn bộ.

TRẠNG THÁI CIRCUIT BREAKER:
  closed (gọi bình thường)
    -- lỗi vượt ngưỡng -->
  open (chặn, trả lỗi/fallback ngay)
    -- sau thời gian chờ -->
  half-open (thử vài lời gọi) -- ok --> closed  | -- lỗi --> open

VÍ DỤ (opossum, Node.js):
  const CircuitBreaker = require("opossum");
  const breaker = new CircuitBreaker(callPaymentApi, {
    timeout: 3000,                // 3s không phản hồi -> coi là lỗi
    errorThresholdPercentage: 50, // > 50% lỗi -> mở mạch
    resetTimeout: 10000,          // 10s sau -> half-open thử lại
  });
  breaker.fallback(() => ({ queued: true }));   // fallback khi mở mạch
  await breaker.fire(order);

GIẢI THÍCH: mở mạch giúp KHÔNG dồn thêm request vào service đang chết,
trả lỗi nhanh để phần còn lại của hệ thống vẫn phản hồi được.'
,description_en=
'In a distributed system, network failures are NORMAL -> you must prevent
cascading failures from bringing down the whole system.

TECHNIQUES:
  • Timeout         : always set one; never wait forever on a slow service.
  • Retry + backoff : retry with INCREASING delay + jitter (avoid a
    retry storm flooding an already weak service).
  • Circuit breaker : a target keeps failing -> "open the circuit", return
    a fast error/fallback for a while -> let the target recover.
  • Bulkhead        : isolate resources (separate pools) so one failing
    part does not sink everything.

CIRCUIT BREAKER STATES:
  closed (normal calls)
    -- errors exceed threshold -->
  open (blocked, fast error/fallback)
    -- after a wait -->
  half-open (try a few calls) -- ok --> closed  | -- fail --> open

EXAMPLE (opossum, Node.js):
  const CircuitBreaker = require("opossum");
  const breaker = new CircuitBreaker(callPaymentApi, {
    timeout: 3000,                // no response in 3s -> treated as failure
    errorThresholdPercentage: 50, // > 50% failures -> open the circuit
    resetTimeout: 10000,          // after 10s -> half-open, retry
  });
  breaker.fallback(() => ({ queued: true }));   // fallback when open
  await breaker.fire(order);

EXPLANATION: opening the circuit avoids piling more requests onto a dying
service, failing fast so the rest of the system stays responsive.'
WHERE id='n_ms_circuit';
