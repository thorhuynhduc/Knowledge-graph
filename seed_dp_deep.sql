-- ĐÀO SÂU Design Patterns (đợt 3a): Strategy, Factory, Singleton, Observer
UPDATE kg_nodes SET
description=
'Strategy đóng gói nhiều THUẬT TOÁN thay thế nhau, chọn lúc chạy -> khử
if/else phình to, tuân Open/Closed.

TRƯỚC (if/else phình; thêm hãng phải sửa hàm cũ):
  function shippingCost(order, carrier) {
    if (carrier === "fedex")     return order.weight * 2.0;
    else if (carrier === "ups")  return order.weight * 1.8;
    else if (carrier === "self") return 0;
    // thêm hãng mới -> phải sửa hàm này (vi phạm Open/Closed)
  }

SAU (Strategy — mỗi thuật toán một hàm, tra theo key):
  const strategies = {
    fedex: (o) => o.weight * 2.0,
    ups:   (o) => o.weight * 1.8,
    self:  (o) => 0,
  };
  function shippingCost(order, carrier) {
    const strat = strategies[carrier];
    if (!strat) throw new Error("Unknown carrier: " + carrier);
    return strat(order);
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi cách tính = một strategy (hàm/lớp cùng "hình dạng" gọi).
  2. Chọn strategy lúc chạy qua key (carrier).
  3. Thêm hãng mới = THÊM một entry, KHÔNG sửa shippingCost.

ỨNG DỤNG: tính giá/thuế, thuật toán nén, chiến lược retry, xác thực
nhiều kiểu (JWT / OAuth / API key).'
,description_en=
'Strategy encapsulates interchangeable ALGORITHMS chosen at runtime ->
removes bloated if/else, follows Open/Closed.

BEFORE (bloated if/else; adding a carrier edits the old function):
  function shippingCost(order, carrier) {
    if (carrier === "fedex")     return order.weight * 2.0;
    else if (carrier === "ups")  return order.weight * 1.8;
    else if (carrier === "self") return 0;
    // a new carrier -> must edit this function (breaks Open/Closed)
  }

AFTER (Strategy - one function per algorithm, looked up by key):
  const strategies = {
    fedex: (o) => o.weight * 2.0,
    ups:   (o) => o.weight * 1.8,
    self:  (o) => 0,
  };
  function shippingCost(order, carrier) {
    const strat = strategies[carrier];
    if (!strat) throw new Error("Unknown carrier: " + carrier);
    return strat(order);
  }

STEP BY STEP:
  1. Each calculation = a strategy (a function/class with the same call shape).
  2. Pick the strategy at runtime by key (carrier).
  3. A new carrier = ADD an entry, do NOT edit shippingCost.

USES: pricing/tax, compression algorithms, retry strategies, multiple
auth methods (JWT / OAuth / API key).'
WHERE id='n_dp_strategy';

UPDATE kg_nodes SET
description=
'Factory tách việc TẠO object khỏi nơi dùng -> đổi loại object mà không
sửa code gọi.

TRƯỚC (nơi dùng tự new, phụ thuộc lớp cụ thể, logic tạo rải rác):
  let logger;
  if (env === "prod") logger = new CloudLogger(apiKey);
  else                logger = new ConsoleLogger();

SAU (Factory gom việc tạo về một chỗ):
  function createLogger(env) {
    switch (env) {
      case "prod": return new CloudLogger(process.env.LOG_KEY);
      case "file": return new FileLogger("/var/log/app.log");
      default:     return new ConsoleLogger();
    }
  }
  const logger = createLogger(process.env.NODE_ENV);

GIẢI THÍCH TỪNG BƯỚC:
  1. Client chỉ gọi createLogger(), KHÔNG biết lớp cụ thể nào được tạo.
  2. Đổi/thêm loại logger -> chỉ sửa factory, nơi dùng giữ nguyên.
  3. Abstract Factory: tạo cả một HỌ object liên quan (vd theme UI:
     createButton() + createInput() cùng phong cách).

DÙNG KHI: khởi tạo phức tạp, phụ thuộc cấu hình/điều kiện, hoặc muốn
giấu chi tiết lớp cụ thể khỏi client (giảm coupling).'
,description_en=
'A Factory separates object CREATION from its use -> change the object
type without editing the calling code.

BEFORE (callers new directly, depend on concrete classes, scattered logic):
  let logger;
  if (env === "prod") logger = new CloudLogger(apiKey);
  else                logger = new ConsoleLogger();

AFTER (a Factory gathers creation in one place):
  function createLogger(env) {
    switch (env) {
      case "prod": return new CloudLogger(process.env.LOG_KEY);
      case "file": return new FileLogger("/var/log/app.log");
      default:     return new ConsoleLogger();
    }
  }
  const logger = createLogger(process.env.NODE_ENV);

STEP BY STEP:
  1. The client only calls createLogger(), unaware of the concrete class.
  2. Changing/adding a logger type -> edit only the factory; callers stay.
  3. Abstract Factory: create a whole FAMILY of related objects (e.g. a
     UI theme: createButton() + createInput() in one style).

USE WHEN: creation is complex, depends on config/conditions, or you want
to hide concrete classes from the client (reduce coupling).'
WHERE id='n_dp_factory';

UPDATE kg_nodes SET
description=
'Đảm bảo một lớp CHỈ có một instance, chia sẻ toàn cục (connection pool,
config, logger).

CÁCH 1 — trong Node, module cache là singleton TỰ NHIÊN:
  // db.js
  const { Pool } = require("pg");
  const pool = new Pool({ max: 10 });
  module.exports = pool;        // mọi require dùng CHUNG một pool

  // a.js: const pool = require("./db");   -> cùng instance
  // b.js: const pool = require("./db");   -> cùng instance đó

CÁCH 2 — bằng class (lười khởi tạo):
  class Config {
    static #instance;
    static get() {
      if (!Config.#instance) Config.#instance = new Config();
      return Config.#instance;
    }
  }
  const cfg = Config.get();

GIẢI THÍCH & CẢNH BÁO:
  1. Node cache module theo đường dẫn -> export sẵn 1 instance là đủ.
  2. Singleton = GLOBAL STATE -> khó test (khó reset giữa các test), ẩn
     phụ thuộc, dễ tạo coupling ngầm.
  3. Nhiều trường hợp NÊN dùng Dependency Injection (truyền pool/config
     vào) thay vì singleton cứng -> dễ mock, dễ thay thế khi test.'
,description_en=
'Ensures a class has only one instance, shared globally (connection pool,
config, logger).

WAY 1 - in Node, the module cache is a NATURAL singleton:
  // db.js
  const { Pool } = require("pg");
  const pool = new Pool({ max: 10 });
  module.exports = pool;        // every require shares the SAME pool

  // a.js: const pool = require("./db");   -> same instance
  // b.js: const pool = require("./db");   -> that same instance

WAY 2 - via a class (lazy init):
  class Config {
    static #instance;
    static get() {
      if (!Config.#instance) Config.#instance = new Config();
      return Config.#instance;
    }
  }
  const cfg = Config.get();

EXPLANATION & WARNING:
  1. Node caches modules by path -> exporting one instance is enough.
  2. A singleton = GLOBAL STATE -> hard to test (hard to reset between
     tests), hides dependencies, encourages hidden coupling.
  3. Often prefer Dependency Injection (pass the pool/config in) over a
     hard singleton -> easy to mock and swap in tests.'
WHERE id='n_dp_singleton';

UPDATE kg_nodes SET
description=
'Observer: khi subject đổi trạng thái, nó tự động THÔNG BÁO các observer
đã đăng ký. Nền của lập trình event-driven.

TRƯỚC (gọi trực tiếp -> coupling chặt, thêm việc phải sửa hàm):
  function registerUser(u) {
    saveUser(u);
    sendWelcomeEmail(u);   // hàm đăng ký phải BIẾT mọi việc phụ
    createAuditLog(u);     // thêm việc -> lại sửa hàm này
    addToCrm(u);
  }

SAU (Observer -> subject không cần biết ai đang nghe):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();

  bus.on("userRegistered", (u) => sendWelcomeEmail(u));
  bus.on("userRegistered", (u) => createAuditLog(u));
  bus.on("userRegistered", (u) => addToCrm(u));

  function registerUser(u) {
    saveUser(u);
    bus.emit("userRegistered", u);   // chỉ phát sự kiện
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Subject (registerUser) chỉ EMIT sự kiện, không biết có bao nhiêu
     observer đang nghe.
  2. Thêm phản ứng mới = THÊM một listener, KHÔNG sửa registerUser.
  3. emit là ĐỒNG BỘ trong Node -> observer nặng nên đẩy sang hàng đợi.

XUẤT HIỆN Ở: EventEmitter, RxJS, reactivity của Vue, addEventListener
của DOM, message bus trong microservices.'
,description_en=
'Observer: when a subject changes state, it automatically NOTIFIES its
registered observers. The basis of event-driven programming.

BEFORE (direct calls -> tight coupling; adding work edits the function):
  function registerUser(u) {
    saveUser(u);
    sendWelcomeEmail(u);   // the register function must KNOW every side task
    createAuditLog(u);     // adding a task -> edit this function again
    addToCrm(u);
  }

AFTER (Observer -> the subject need not know who listens):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();

  bus.on("userRegistered", (u) => sendWelcomeEmail(u));
  bus.on("userRegistered", (u) => createAuditLog(u));
  bus.on("userRegistered", (u) => addToCrm(u));

  function registerUser(u) {
    saveUser(u);
    bus.emit("userRegistered", u);   // just emit an event
  }

STEP BY STEP:
  1. The subject (registerUser) only EMITs; it does not know how many
     observers listen.
  2. A new reaction = ADD a listener, do NOT edit registerUser.
  3. emit is SYNCHRONOUS in Node -> push heavy observers to a queue.

APPEARS IN: EventEmitter, RxJS, Vue reactivity, DOM addEventListener,
the message bus in microservices.'
WHERE id='n_dp_observer';
