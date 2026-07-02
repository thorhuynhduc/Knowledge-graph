-- ===================================================================
--  TOPIC: Design Patterns (song ngữ VI + EN, ví dụ JS/TS)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_patterns.sql
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_dp','Design Patterns','Architecture',
'Các mẫu thiết kế kinh điển (Gang of Four) và nguyên lý SOLID, kèm ví dụ JS/TS: nhóm Creational, Structural, Behavioral, và vài pattern thực tế trong backend.',
'Classic design patterns (Gang of Four) and SOLID principles, with JS/TS examples: the Creational, Structural, and Behavioral groups, plus a few practical backend patterns.',
'[]',150,1650),

('s_dp_1','Nguyên lý & Tổng quan','Architecture',
'Pattern là gì, 3 nhóm GoF, nguyên lý SOLID và vài pattern thực tế trong backend.',
'What a pattern is, the 3 GoF groups, SOLID principles, and a few practical backend patterns.',
'[]',60,1550),
('s_dp_2','Creational','Architecture',
'Các mẫu về cách TẠO object: Singleton, Factory, Builder.',
'Patterns about how to CREATE objects: Singleton, Factory, Builder.',
'[]',260,1550),
('s_dp_3','Structural','Architecture',
'Các mẫu GHÉP object/lớp: Adapter, Decorator, Facade, Proxy.',
'Patterns for COMPOSING objects/classes: Adapter, Decorator, Facade, Proxy.',
'[]',60,1780),
('s_dp_4','Behavioral','Architecture',
'Các mẫu về cách object TƯƠNG TÁC: Strategy, Observer, Command.',
'Patterns about how objects INTERACT: Strategy, Observer, Command.',
'[]',260,1780),

-- ===== Section 1 =====
('n_dp_intro','Design Pattern là gì?','Architecture',
'Design pattern là giải pháp MẪU cho các vấn đề thiết kế lặp lại —
không phải code copy-paste mà là cách tổ chức. Nhóm Gang of Four
(GoF) chia 23 pattern thành 3 nhóm:

  • Creational  : cách TẠO object (Singleton, Factory, Builder...)
  • Structural  : cách GHÉP object/lớp (Adapter, Decorator, Facade)
  • Behavioral  : cách object TƯƠNG TÁC (Strategy, Observer, Command)

Mục đích: code dễ mở rộng, giảm phụ thuộc, dễ test, và tạo NGÔN
NGỮ CHUNG khi trao đổi trong đội (nói "dùng Strategy" là hiểu ngay).

Lưu ý quan trọng: đừng lạm dụng. Chỉ áp pattern khi vấn đề thực sự
xuất hiện; nhồi pattern vào chỗ đơn giản là over-engineering.',
'A design pattern is a TEMPLATE solution to recurring design
problems - not copy-paste code but a way to organize it. The Gang
of Four (GoF) groups 23 patterns into 3 categories:

  • Creational  : how to CREATE objects (Singleton, Factory, Builder)
  • Structural  : how to COMPOSE objects/classes (Adapter, Decorator,
                  Facade)
  • Behavioral  : how objects INTERACT (Strategy, Observer, Command)

Purpose: code that is easier to extend, less coupled, and easier to
test, plus a SHARED VOCABULARY for the team (saying "use Strategy"
is instantly understood).

Important: do not overuse them. Apply a pattern only when the
problem actually appears; forcing patterns into simple code is
over-engineering.',
'[]',20,1490),

('n_dp_solid','SOLID principles','Architecture',
'SOLID là 5 nguyên lý thiết kế hướng đối tượng, nền của nhiều pattern:

  S - Single Responsibility: một lớp chỉ có MỘT lý do để thay đổi.
  O - Open/Closed          : mở để MỞ RỘNG, đóng để SỬA ĐỔI.
  L - Liskov Substitution  : lớp con phải thay được lớp cha mà không
                             phá hành vi.
  I - Interface Segregation: nhiều interface nhỏ, chuyên biệt hơn
                             một interface to.
  D - Dependency Inversion : phụ thuộc ABSTRACTION, không phụ thuộc
                             chi tiết cụ thể.

Ví dụ (D - inject abstraction):
  class OrderService {
    constructor(repo) { this.repo = repo; }  // repo: 1 interface
    save(o) { return this.repo.insert(o); }
  }
  // Đổi repo (Postgres/Mongo) KHÔNG cần sửa OrderService,
  // và dễ mock repo khi test.',
'SOLID is a set of 5 object-oriented design principles, the basis of
many patterns:

  S - Single Responsibility: a class has only ONE reason to change.
  O - Open/Closed          : open to EXTENSION, closed to MODIFICATION.
  L - Liskov Substitution  : a subclass must be substitutable for its
                             base without breaking behavior.
  I - Interface Segregation: many small, specific interfaces beat one
                             large interface.
  D - Dependency Inversion : depend on ABSTRACTIONS, not on concrete
                             details.

Example (D - inject an abstraction):
  class OrderService {
    constructor(repo) { this.repo = repo; }  // repo: an interface
    save(o) { return this.repo.insert(o); }
  }
  // Swapping repo (Postgres/Mongo) needs NO change to OrderService,
  // and repo is easy to mock in tests.',
'[]',100,1490),

('n_dp_backend','Pattern thực tế trong backend','Architecture',
'Vài pattern hay gặp ngoài GoF, rất phổ biến trong Node/backend:

  • Repository : tách logic truy cập dữ liệu khỏi business logic.
      class UserRepo { findById(id){ /* SQL */ } }
    -> service không biết dùng SQL hay Mongo.

  • Dependency Injection : truyền phụ thuộc từ ngoài vào thay vì tự
    tạo bên trong -> dễ test, dễ thay thế (nền của NestJS).

  • Middleware / Chain of Responsibility : xử lý request qua chuỗi
    hàm (Express): auth -> log -> validate -> handler.

  • DTO : object định dạng dữ liệu vào/ra, tách khỏi entity DB.

Những pattern này giải quyết vấn đề thực tế: tách lớp, dễ test, dễ
bảo trì — quan trọng hơn việc thuộc lòng đủ 23 GoF.',
'A few patterns beyond GoF that are very common in Node/backend:

  • Repository : separates data-access logic from business logic.
      class UserRepo { findById(id){ /* SQL */ } }
    -> the service does not know whether it uses SQL or Mongo.

  • Dependency Injection : pass dependencies in from outside instead
    of creating them inside -> easy to test and swap (the basis of
    NestJS).

  • Middleware / Chain of Responsibility : process a request through
    a chain of functions (Express): auth -> log -> validate -> handler.

  • DTO : an object shaping input/output data, separate from the DB
    entity.

These solve real problems: layering, testability, maintainability -
more important than memorizing all 23 GoF patterns.',
'[]',60,1610),

-- ===== Section 2: Creational =====
('n_dp_singleton','Singleton','Architecture',
'Đảm bảo một lớp CHỈ có một instance duy nhất, chia sẻ toàn cục.
Hay dùng cho: connection pool, config, logger.

Trong Node, module được cache nên xuất một instance là singleton
tự nhiên:
  // db.js
  const pool = createPool();
  module.exports = pool;   // mọi require dùng CHUNG một pool

  // a.js và b.js cùng require("./db") -> cùng pool

Cẩn thận: singleton là GLOBAL STATE -> khó test (khó reset giữa
các test), ẩn phụ thuộc, dễ gây coupling. Nhiều trường hợp nên
dùng Dependency Injection thay vì singleton cứng.',
'Ensures a class has only ONE instance, shared globally. Common for:
connection pools, config, loggers.

In Node, modules are cached, so exporting one instance is a natural
singleton:
  // db.js
  const pool = createPool();
  module.exports = pool;   // every require shares the SAME pool

  // a.js and b.js both require("./db") -> same pool

Caution: a singleton is GLOBAL STATE -> hard to test (hard to reset
between tests), hides dependencies, and encourages coupling. Often
prefer Dependency Injection over a hard singleton.',
'[]',220,1490),

('n_dp_factory','Factory','Architecture',
'Factory tách việc TẠO object khỏi nơi sử dụng -> dễ đổi loại
object mà không sửa code gọi.

Factory Method (chọn lớp con lúc chạy):
  function createLogger(type) {
    if (type === "file")  return new FileLogger();
    if (type === "cloud") return new CloudLogger();
    return new ConsoleLogger();
  }
  const log = createLogger(process.env.LOG_TYPE);

Abstract Factory: tạo cả một HỌ object liên quan (vd bộ UI theo
theme: DarkButton + DarkInput).

Dùng khi: việc khởi tạo phức tạp, phụ thuộc cấu hình/điều kiện,
hoặc muốn giấu chi tiết lớp cụ thể khỏi client.',
'A Factory separates object CREATION from its use -> easy to change
the object type without touching the calling code.

Factory Method (pick a subclass at runtime):
  function createLogger(type) {
    if (type === "file")  return new FileLogger();
    if (type === "cloud") return new CloudLogger();
    return new ConsoleLogger();
  }
  const log = createLogger(process.env.LOG_TYPE);

Abstract Factory: creates a whole FAMILY of related objects (e.g. a
themed UI set: DarkButton + DarkInput).

Use when: creation is complex, depends on config/conditions, or you
want to hide concrete classes from the client.',
'[]',300,1490),

('n_dp_builder','Builder','Architecture',
'Builder dựng một object phức tạp theo TỪNG BƯỚC, tránh constructor
với quá nhiều tham số khó nhớ.

Ví dụ (fluent, nối chuỗi):
  const query = new QueryBuilder()
    .select("id", "name")
    .from("users")
    .where("age > 18")
    .orderBy("name")
    .build();   // build() trả về kết quả cuối

So với constructor dài dễ nhầm thứ tự:
  new Query("users", ["id","name"], "age>18", null, "name"); // khó đọc

Dùng khi object có nhiều tùy chọn KHÔNG bắt buộc, hoặc cần dựng
linh hoạt (query builder, HTTP request builder, cấu hình).',
'A Builder constructs a complex object STEP BY STEP, avoiding a
constructor with too many hard-to-remember parameters.

Example (fluent, chained):
  const query = new QueryBuilder()
    .select("id", "name")
    .from("users")
    .where("age > 18")
    .orderBy("name")
    .build();   // build() returns the final result

Versus a long constructor with error-prone order:
  new Query("users", ["id","name"], "age>18", null, "name"); // unreadable

Use when an object has many OPTIONAL settings, or needs flexible
construction (query builder, HTTP request builder, config).',
'[]',220,1610),

-- ===== Section 3: Structural =====
('n_dp_adapter','Adapter','Architecture',
'Adapter là CẦU NỐI giữa hai interface không tương thích — bọc một
API cũ/bên thứ ba thành interface mà app mong đợi.

Ví dụ: app cần interface { pay(amount) } nhưng Stripe có API khác:
  class StripeAdapter {
    constructor(stripe) { this.s = stripe; }
    pay(amount) {
      return this.s.charges.create({ amount, currency: "usd" });
    }
  }
  // app chỉ gọi paymentGateway.pay(100), không biết đó là Stripe

Lợi ích: đổi nhà cung cấp (Stripe -> Paypal) chỉ cần viết adapter
mới, code nghiệp vụ không đổi. Rất hợp khi tích hợp thư viện ngoài.',
'An Adapter is a BRIDGE between two incompatible interfaces - it
wraps a legacy/third-party API into the interface your app expects.

Example: the app needs { pay(amount) } but Stripe has a different API:
  class StripeAdapter {
    constructor(stripe) { this.s = stripe; }
    pay(amount) {
      return this.s.charges.create({ amount, currency: "usd" });
    }
  }
  // the app just calls paymentGateway.pay(100), unaware it is Stripe

Benefit: switching providers (Stripe -> Paypal) only needs a new
adapter; business code stays the same. Great for integrating
external libraries.',
'[]',20,1720),

('n_dp_decorator','Decorator','Architecture',
'Decorator THÊM hành vi cho một object mà không sửa lớp gốc, bằng
cách BỌC nó; có thể ghép nhiều lớp bọc.

Ví dụ (bọc hàm bằng logging + cache):
  const withLogging = fn => (...a) => { console.log(a); return fn(...a); };
  const withCache = fn => {
    const m = new Map();
    return x => m.has(x) ? m.get(x) : (m.set(x, fn(x)), m.get(x));
  };
  const smart = withLogging(withCache(compute));  // ghép chồng

Ứng dụng thực tế: middleware Express (mỗi lớp thêm 1 việc),
TypeScript decorators (@Injectable), higher-order component.

Ưu điểm so với kế thừa: linh hoạt, ghép động lúc chạy, tuân
Open/Closed.',
'A Decorator ADDS behavior to an object without modifying the
original class, by WRAPPING it; multiple wrappers can be composed.

Example (wrap a function with logging + cache):
  const withLogging = fn => (...a) => { console.log(a); return fn(...a); };
  const withCache = fn => {
    const m = new Map();
    return x => m.has(x) ? m.get(x) : (m.set(x, fn(x)), m.get(x));
  };
  const smart = withLogging(withCache(compute));  // stacked

Real-world uses: Express middleware (each layer adds one concern),
TypeScript decorators (@Injectable), higher-order components.

Advantage over inheritance: flexible, composed at runtime, follows
Open/Closed.',
'[]',100,1720),

('n_dp_facade','Facade','Architecture',
'Facade cung cấp MỘT interface đơn giản che giấu một hệ thống con
phức tạp gồm nhiều lớp/bước.

Ví dụ: chuyển đổi video gồm nhiều bước, gói lại sau 1 hàm:
  class MediaConverter {
    convert(file) {
      const raw = this.decoder.decode(file);
      const small = this.resizer.resize(raw);
      const out = this.encoder.encode(small);
      return this.uploader.upload(out);
    }
  }
  media.convert("clip.mov");  // client không cần biết 4 bước bên trong

Lợi ích: giảm ghép nối giữa client và hệ thống con, dễ dùng, dễ
đổi bên trong. Khác Adapter (đổi interface cho tương thích),
Facade chỉ đơn giản hoá.',
'A Facade provides ONE simple interface that hides a complex
subsystem of many classes/steps.

Example: video conversion has many steps, wrapped behind one method:
  class MediaConverter {
    convert(file) {
      const raw = this.decoder.decode(file);
      const small = this.resizer.resize(raw);
      const out = this.encoder.encode(small);
      return this.uploader.upload(out);
    }
  }
  media.convert("clip.mov");  // the client need not know the 4 steps

Benefit: reduces coupling between the client and the subsystem, is
easy to use, and easy to change internally. Unlike Adapter (which
changes an interface for compatibility), a Facade simply
simplifies.',
'[]',20,1780),

('n_dp_proxy','Proxy','Architecture',
'Proxy đứng THAY cho object thật để kiểm soát truy cập: lazy load,
cache, kiểm tra quyền, logging — cùng interface với object thật.

Ví dụ (JS Proxy chặn truy cập trường nhạy cảm):
  const safeUser = new Proxy(user, {
    get(obj, key) {
      if (key === "ssn") throw new Error("Cấm truy cập");
      return obj[key];
    }
  });

Các biến thể:
  • Virtual proxy : trì hoãn tạo object nặng tới khi cần (lazy).
  • Protection    : kiểm tra quyền trước khi cho gọi.
  • Remote        : gọi service từ xa nhưng trông như gọi local.

Khác Decorator (thêm hành vi), Proxy tập trung KIỂM SOÁT truy cập.',
'A Proxy stands IN FOR the real object to control access: lazy
loading, caching, permission checks, logging - with the same
interface as the real object.

Example (a JS Proxy blocking access to a sensitive field):
  const safeUser = new Proxy(user, {
    get(obj, key) {
      if (key === "ssn") throw new Error("Access denied");
      return obj[key];
    }
  });

Variants:
  • Virtual proxy : defer creating a heavy object until needed (lazy).
  • Protection    : check permissions before allowing a call.
  • Remote        : call a remote service as if it were local.

Unlike Decorator (which adds behavior), a Proxy focuses on
CONTROLLING access.',
'[]',100,1780),

-- ===== Section 4: Behavioral =====
('n_dp_strategy','Strategy','Architecture',
'Strategy đóng gói nhiều THUẬT TOÁN có thể thay thế nhau, chọn lúc
chạy -> loại bỏ khối if/else lớn và tuân Open/Closed.

Ví dụ (phí vận chuyển theo hãng):
  const strategies = {
    fedex: order => order.weight * 2.0,
    ups:   order => order.weight * 1.8,
    self:  order => 0,
  };
  function shippingCost(order, carrier) {
    return strategies[carrier](order);
  }

Thêm hãng mới = thêm MỘT hàm, KHÔNG sửa chỗ gọi. Đây là cách khử
if/else phình to theo loại.

Rất phổ biến: cách tính giá, thuật toán nén, chiến lược retry.',
'Strategy encapsulates several interchangeable ALGORITHMS chosen at
runtime -> removes big if/else blocks and follows Open/Closed.

Example (shipping cost per carrier):
  const strategies = {
    fedex: order => order.weight * 2.0,
    ups:   order => order.weight * 1.8,
    self:  order => 0,
  };
  function shippingCost(order, carrier) {
    return strategies[carrier](order);
  }

Adding a new carrier = adding ONE function, NO change to the caller.
This is how you eliminate if/else that grows with each type.

Very common: pricing, compression algorithms, retry strategies.',
'[]',220,1720),

('n_dp_observer','Observer','Architecture',
'Observer: khi một đối tượng (subject) đổi trạng thái, nó tự động
THÔNG BÁO mọi observer đã đăng ký. Đây là nền của lập trình
event-driven.

Ví dụ (EventEmitter của Node):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("userRegistered", user => sendWelcomeEmail(user));
  bus.on("userRegistered", user => createAuditLog(user));
  bus.emit("userRegistered", newUser);  // CẢ HAI observer chạy

Lợi ích: subject không cần biết ai đang nghe -> giảm ghép nối, dễ
thêm phản ứng mới.

Xuất hiện khắp nơi: EventEmitter, RxJS (Observable), hệ reactivity
của Vue, DOM addEventListener.',
'Observer: when a subject changes state, it automatically NOTIFIES
all registered observers. This is the basis of event-driven
programming.

Example (Node EventEmitter):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("userRegistered", user => sendWelcomeEmail(user));
  bus.on("userRegistered", user => createAuditLog(user));
  bus.emit("userRegistered", newUser);  // BOTH observers run

Benefit: the subject need not know who is listening -> less
coupling, easy to add new reactions.

It appears everywhere: EventEmitter, RxJS (Observable), the Vue
reactivity system, DOM addEventListener.',
'[]',300,1720),

('n_dp_command','Command','Architecture',
'Command đóng gói một YÊU CẦU thành object -> cho phép xếp hàng
(queue), hoàn tác (undo), ghi log, và thử lại (retry).

Ví dụ (thêm/hoàn tác vào giỏ hàng):
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }
  const history = [];
  function run(cmd) { cmd.execute(); history.push(cmd); }
  function undoLast() { history.pop()?.undo(); }

Vì mỗi hành động là một object, ta lưu lịch sử để undo/redo, đẩy
vào hàng đợi job, hoặc serialize để chạy sau.

Hợp cho: job queue, undo/redo (editor), transaction script.',
'Command encapsulates a REQUEST as an object -> enabling queuing,
undo, logging, and retry.

Example (add/undo on a shopping cart):
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }
  const history = [];
  function run(cmd) { cmd.execute(); history.push(cmd); }
  function undoLast() { history.pop()?.undo(); }

Because each action is an object, you can keep a history for
undo/redo, push it into a job queue, or serialize it to run later.

Good for: job queues, undo/redo (editors), transaction scripts.',
'[]',300,1780)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_dp_part-of','root','t_dp','part-of'),
('e_t_dp_s_dp_1_part-of','t_dp','s_dp_1','part-of'),
('e_t_dp_s_dp_2_part-of','t_dp','s_dp_2','part-of'),
('e_t_dp_s_dp_3_part-of','t_dp','s_dp_3','part-of'),
('e_t_dp_s_dp_4_part-of','t_dp','s_dp_4','part-of'),
('e_s_dp_1_n_dp_intro','s_dp_1','n_dp_intro','part-of'),
('e_s_dp_1_n_dp_solid','s_dp_1','n_dp_solid','part-of'),
('e_s_dp_1_n_dp_backend','s_dp_1','n_dp_backend','part-of'),
('e_s_dp_2_n_dp_singleton','s_dp_2','n_dp_singleton','part-of'),
('e_s_dp_2_n_dp_factory','s_dp_2','n_dp_factory','part-of'),
('e_s_dp_2_n_dp_builder','s_dp_2','n_dp_builder','part-of'),
('e_s_dp_3_n_dp_adapter','s_dp_3','n_dp_adapter','part-of'),
('e_s_dp_3_n_dp_decorator','s_dp_3','n_dp_decorator','part-of'),
('e_s_dp_3_n_dp_facade','s_dp_3','n_dp_facade','part-of'),
('e_s_dp_3_n_dp_proxy','s_dp_3','n_dp_proxy','part-of'),
('e_s_dp_4_n_dp_strategy','s_dp_4','n_dp_strategy','part-of'),
('e_s_dp_4_n_dp_observer','s_dp_4','n_dp_observer','part-of'),
('e_s_dp_4_n_dp_command','s_dp_4','n_dp_command','part-of'),
('e_n_dp_observer_n_ee_basic_rel','n_dp_observer','n_ee_basic','related'),
('e_n_dp_decorator_q_38_rel','n_dp_decorator','q_38','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
