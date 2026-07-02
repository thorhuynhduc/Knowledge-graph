-- ĐÀO SÂU Design Patterns (đợt 3c): Builder, Command, Intro, Backend patterns
UPDATE kg_nodes SET
description=
'Builder dựng object phức tạp theo TỪNG BƯỚC, tránh constructor nhiều
tham số khó nhớ.

TRƯỚC (constructor dài, dễ nhầm thứ tự/nghĩa tham số):
  new Query("users", ["id","name"], "age>18", null, "name", 10);
  // tham số null + thứ tự -> khó đọc, dễ sai

SAU (Builder fluent — nối chuỗi, rõ nghĩa):
  class QueryBuilder {
    #p = { cols: ["*"], where: [], order: null, limit: null };
    select(...c) { this.#p.cols = c;  return this; }
    from(t)      { this.#p.table = t; return this; }
    where(w)     { this.#p.where.push(w); return this; }
    orderBy(o)   { this.#p.order = o; return this; }
    limit(n)     { this.#p.limit = n; return this; }
    build() {
      let q = `SELECT ${this.#p.cols.join(",")} FROM ${this.#p.table}`;
      if (this.#p.where.length) q += " WHERE " + this.#p.where.join(" AND ");
      if (this.#p.order) q += " ORDER BY " + this.#p.order;
      if (this.#p.limit) q += " LIMIT " + this.#p.limit;
      return q;
    }
  }
  const sql = new QueryBuilder()
    .select("id","name").from("users").where("age>18")
    .orderBy("name").limit(10).build();

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi bước trả về this -> nối chuỗi được (fluent).
  2. build() ráp kết quả cuối cùng.
  3. Bỏ qua bước không cần (where/limit tùy chọn) -> linh hoạt.

DÙNG KHI: object nhiều tùy chọn KHÔNG bắt buộc (query builder, HTTP
request builder, cấu hình phức tạp).'
,description_en=
'A Builder constructs a complex object STEP BY STEP, avoiding a
constructor with too many hard-to-remember parameters.

BEFORE (a long constructor, easy to mix up order/meaning):
  new Query("users", ["id","name"], "age>18", null, "name", 10);
  // null args + positional order -> unreadable, error-prone

AFTER (a fluent Builder - chained, self-describing):
  class QueryBuilder {
    #p = { cols: ["*"], where: [], order: null, limit: null };
    select(...c) { this.#p.cols = c;  return this; }
    from(t)      { this.#p.table = t; return this; }
    where(w)     { this.#p.where.push(w); return this; }
    orderBy(o)   { this.#p.order = o; return this; }
    limit(n)     { this.#p.limit = n; return this; }
    build() {
      let q = `SELECT ${this.#p.cols.join(",")} FROM ${this.#p.table}`;
      if (this.#p.where.length) q += " WHERE " + this.#p.where.join(" AND ");
      if (this.#p.order) q += " ORDER BY " + this.#p.order;
      if (this.#p.limit) q += " LIMIT " + this.#p.limit;
      return q;
    }
  }
  const sql = new QueryBuilder()
    .select("id","name").from("users").where("age>18")
    .orderBy("name").limit(10).build();

STEP BY STEP:
  1. Each step returns this -> chainable (fluent).
  2. build() assembles the final result.
  3. Skip unneeded steps (where/limit optional) -> flexible.

USE WHEN: an object has many OPTIONAL settings (query builder, HTTP
request builder, complex config).'
WHERE id='n_dp_builder';

UPDATE kg_nodes SET
description=
'Command đóng gói một YÊU CẦU thành object -> cho phép hàng đợi, hoàn
tác (undo), log, retry.

VÍ DỤ giỏ hàng có undo:
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }

  const history = [];
  function run(cmd)   { cmd.execute(); history.push(cmd); }
  function undoLast() { const c = history.pop(); if (c) c.undo(); }

  run(new AddItemCommand(cart, phone));   // thêm phone
  run(new AddItemCommand(cart, cover));   // thêm cover
  undoLast();                             // bỏ cover (gọi undo)

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi hành động = một object có execute() và undo().
  2. Lưu history -> undo/redo dễ dàng.
  3. Vì là OBJECT -> có thể đẩy vào job queue, serialize để chạy sau, retry.

ỨNG DỤNG: job queue (BullMQ), undo/redo trong editor, transaction
script, ghi log lệnh (hướng event sourcing).'
,description_en=
'Command encapsulates a REQUEST as an object -> enabling queuing, undo,
logging, and retry.

SHOPPING-CART EXAMPLE with undo:
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }

  const history = [];
  function run(cmd)   { cmd.execute(); history.push(cmd); }
  function undoLast() { const c = history.pop(); if (c) c.undo(); }

  run(new AddItemCommand(cart, phone));   // add phone
  run(new AddItemCommand(cart, cover));   // add cover
  undoLast();                             // remove cover (calls undo)

STEP BY STEP:
  1. Each action = an object with execute() and undo().
  2. Keep a history -> easy undo/redo.
  3. Because it is an OBJECT -> you can push it to a job queue, serialize
     it to run later, or retry it.

USES: job queues (BullMQ), editor undo/redo, transaction scripts,
command logging (toward event sourcing).'
WHERE id='n_dp_command';

UPDATE kg_nodes SET
description=
'Design pattern là giải pháp MẪU cho vấn đề thiết kế lặp lại — cách tổ
chức code, không phải thư viện copy-paste. Gang of Four (GoF) chia 23
pattern thành 3 nhóm:

  • Creational : cách TẠO object
      Singleton, Factory, Builder, Prototype, Abstract Factory
  • Structural : cách GHÉP object/lớp
      Adapter, Decorator, Facade, Proxy, Composite, Bridge
  • Behavioral : cách object TƯƠNG TÁC
      Strategy, Observer, Command, Template Method, State, Iterator

MỖI NHÓM GIẢI QUYẾT MỘT LOẠI VẤN ĐỀ:
  - Khởi tạo phức tạp / tốn kém          -> Creational
  - Kết nối/mở rộng cấu trúc mà ít sửa   -> Structural
  - Nhiều nhánh if/else theo hành vi     -> Behavioral

LỢI ÍCH: dễ mở rộng, giảm phụ thuộc, dễ test, và tạo NGÔN NGỮ CHUNG
(nói "dùng Strategy ở đây" là cả đội hiểu ngay).

QUAN TRỌNG — đừng lạm dụng: pattern là công cụ cho vấn đề CỤ THỂ. Nhồi
pattern vào chỗ đơn giản = over-engineering, code khó đọc hơn. Chỉ áp
khi vấn đề thực sự xuất hiện (code lặp, khó đổi, khó test).'
,description_en=
'A design pattern is a TEMPLATE solution to recurring design problems -
a way to organize code, not a copy-paste library. The Gang of Four
(GoF) groups 23 patterns into 3 categories:

  • Creational : how to CREATE objects
      Singleton, Factory, Builder, Prototype, Abstract Factory
  • Structural : how to COMPOSE objects/classes
      Adapter, Decorator, Facade, Proxy, Composite, Bridge
  • Behavioral : how objects INTERACT
      Strategy, Observer, Command, Template Method, State, Iterator

EACH GROUP SOLVES ONE KIND OF PROBLEM:
  - Complex / expensive creation         -> Creational
  - Connect/extend structure with little edits -> Structural
  - Many behavior-based if/else branches -> Behavioral

BENEFITS: easier to extend, less coupling, easier to test, and a SHARED
VOCABULARY (saying "use Strategy here" is instantly understood).

IMPORTANT - do not overuse: a pattern is a tool for a SPECIFIC problem.
Forcing patterns into simple code = over-engineering, harder to read.
Apply only when the problem actually appears (duplication, hard to
change, hard to test).'
WHERE id='n_dp_intro';

UPDATE kg_nodes SET
description=
'Vài pattern ngoài GoF, rất phổ biến trong Node/backend, kèm ví dụ:

REPOSITORY — tách truy cập dữ liệu khỏi business logic:
  class UserRepo {
    constructor(db) { this.db = db; }
    findById(id) { return this.db.query("SELECT * FROM users WHERE id=$1", [id]); }
    save(u)      { return this.db.query("INSERT ..."); }
  }
  // service dùng repo, KHÔNG biết là SQL hay Mongo -> dễ đổi/test

DEPENDENCY INJECTION — truyền phụ thuộc từ ngoài vào:
  class UserService {
    constructor(userRepo, mailer) {   // inject, KHÔNG tự new bên trong
      this.userRepo = userRepo;
      this.mailer = mailer;
    }
  }
  // test: inject repo/mailer GIẢ (mock) -> test không cần DB thật.
  // Đây là nền của NestJS (DI container).

MIDDLEWARE / CHAIN OF RESPONSIBILITY — xử lý request qua chuỗi:
  app.use(auth);       // -> next()
  app.use(logger);     // -> next()
  app.use(validate);   // -> handler
  // mỗi middleware làm một việc rồi gọi next().

DTO — object định dạng dữ liệu vào/ra, tách khỏi entity DB.

Những pattern này giải quyết: tách lớp, dễ test, dễ bảo trì — quan
trọng hơn việc thuộc lòng đủ 23 GoF.'
,description_en=
'A few patterns beyond GoF, very common in Node/backend, with examples:

REPOSITORY - separates data access from business logic:
  class UserRepo {
    constructor(db) { this.db = db; }
    findById(id) { return this.db.query("SELECT * FROM users WHERE id=$1", [id]); }
    save(u)      { return this.db.query("INSERT ..."); }
  }
  // the service uses repo, unaware it is SQL or Mongo -> easy swap/test

DEPENDENCY INJECTION - pass dependencies in from outside:
  class UserService {
    constructor(userRepo, mailer) {   // injected, NOT newed inside
      this.userRepo = userRepo;
      this.mailer = mailer;
    }
  }
  // test: inject FAKE repo/mailer (mocks) -> no real DB needed.
  // This is the basis of NestJS (a DI container).

MIDDLEWARE / CHAIN OF RESPONSIBILITY - process a request via a chain:
  app.use(auth);       // -> next()
  app.use(logger);     // -> next()
  app.use(validate);   // -> handler
  // each middleware does one thing then calls next().

DTO - an object shaping input/output data, separate from the DB entity.

These solve: layering, testability, maintainability - more important
than memorizing all 23 GoF patterns.'
WHERE id='n_dp_backend';
