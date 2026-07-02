-- ĐÀO SÂU Design Patterns (đợt 3b): Adapter, Decorator, Facade, Proxy
UPDATE kg_nodes SET
description=
'Adapter là CẦU NỐI giữa 2 interface không tương thích — bọc API cũ/bên
thứ ba thành interface mà app mong đợi.

BỐI CẢNH: app định nghĩa interface thanh toán chuẩn:
  async function checkout(gateway, amount) {
    return gateway.pay(amount);   // app chỉ biết .pay()
  }

VẤN ĐỀ: Stripe có API KHÁC (charges.create, đơn vị cent USD).

ADAPTER bọc Stripe về interface chuẩn:
  class StripeAdapter {
    constructor(stripe) { this.stripe = stripe; }
    async pay(amountVnd) {
      const usdCents = Math.round(amountVnd / 25000 * 100);
      const res = await this.stripe.charges.create({
        amount: usdCents, currency: "usd",
      });
      return { id: res.id, ok: res.status === "succeeded" };
    }
  }
  await checkout(new StripeAdapter(stripe), 500000);

GIẢI THÍCH TỪNG BƯỚC:
  1. App phụ thuộc INTERFACE (.pay), không phụ thuộc Stripe cụ thể.
  2. Adapter dịch: tên hàm, đơn vị tiền, định dạng kết quả.
  3. Đổi sang PayPal -> viết PaypalAdapter, checkout() KHÔNG đổi.

DÙNG KHI: tích hợp thư viện/bên thứ ba có API không khớp với app.'
,description_en=
'An Adapter is a BRIDGE between two incompatible interfaces - it wraps a
legacy/third-party API into the interface your app expects.

CONTEXT: the app defines a standard payment interface:
  async function checkout(gateway, amount) {
    return gateway.pay(amount);   // the app only knows .pay()
  }

PROBLEM: Stripe has a DIFFERENT API (charges.create, USD cents).

ADAPTER wraps Stripe into the standard interface:
  class StripeAdapter {
    constructor(stripe) { this.stripe = stripe; }
    async pay(amountVnd) {
      const usdCents = Math.round(amountVnd / 25000 * 100);
      const res = await this.stripe.charges.create({
        amount: usdCents, currency: "usd",
      });
      return { id: res.id, ok: res.status === "succeeded" };
    }
  }
  await checkout(new StripeAdapter(stripe), 500000);

STEP BY STEP:
  1. The app depends on the INTERFACE (.pay), not on Stripe specifically.
  2. The adapter translates: method name, currency unit, result shape.
  3. Switching to PayPal -> write a PaypalAdapter, checkout() is UNCHANGED.

USE WHEN: integrating a library/third party whose API does not match the app.'
WHERE id='n_dp_adapter';

UPDATE kg_nodes SET
description=
'Decorator THÊM hành vi cho object/hàm mà không sửa gốc, bằng cách BỌC
nó; có thể ghép nhiều lớp bọc.

VÍ DỤ bọc hàm bằng logging + cache (ghép chồng):
  const withLogging = (fn) => async (...args) => {
    console.log("call", fn.name, args);
    const r = await fn(...args);
    console.log("->", r);
    return r;
  };
  const withCache = (fn) => {
    const cache = new Map();
    return async (key) => {
      if (cache.has(key)) return cache.get(key);   // hit
      const r = await fn(key);
      cache.set(key, r);
      return r;
    };
  };

  // ghép: logging(cache(fetchUser))
  const smartFetch = withLogging(withCache(fetchUser));
  await smartFetch(42);   // lần 1: chạy thật + log
  await smartFetch(42);   // lần 2: lấy từ cache + log

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi decorator nhận fn, trả về fn MỚI cùng chữ ký -> ghép được.
  2. Thứ tự bọc = thứ tự chạy (ngoài vào trong).
  3. KHÔNG sửa fetchUser gốc -> tuân Open/Closed.

ỨNG DỤNG: middleware Express, TypeScript @Decorator (@Injectable),
higher-order function/component. Khác Proxy (kiểm soát truy cập),
Decorator THÊM tính năng.'
,description_en=
'A Decorator ADDS behavior to an object/function without modifying the
original, by WRAPPING it; multiple wrappers can be composed.

EXAMPLE wrapping a function with logging + cache (stacked):
  const withLogging = (fn) => async (...args) => {
    console.log("call", fn.name, args);
    const r = await fn(...args);
    console.log("->", r);
    return r;
  };
  const withCache = (fn) => {
    const cache = new Map();
    return async (key) => {
      if (cache.has(key)) return cache.get(key);   // hit
      const r = await fn(key);
      cache.set(key, r);
      return r;
    };
  };

  // compose: logging(cache(fetchUser))
  const smartFetch = withLogging(withCache(fetchUser));
  await smartFetch(42);   // 1st: runs for real + logs
  await smartFetch(42);   // 2nd: from cache + logs

STEP BY STEP:
  1. Each decorator takes fn and returns a NEW fn with the same signature
     -> composable.
  2. Wrapping order = execution order (outside in).
  3. It does NOT modify the original fetchUser -> follows Open/Closed.

USES: Express middleware, TypeScript @Decorator (@Injectable),
higher-order functions/components. Unlike Proxy (access control), a
Decorator ADDS features.'
WHERE id='n_dp_decorator';

UPDATE kg_nodes SET
description=
'Facade cung cấp MỘT interface đơn giản che giấu một hệ thống con phức
tạp (nhiều lớp/bước).

TRƯỚC (client phải biết và gọi đúng thứ tự nhiều bước):
  const raw   = decoder.decode(file);
  const small = resizer.resize(raw, 720);
  const enc   = encoder.encode(small, "h264");
  const url   = uploader.upload(enc);
  // client gánh toàn bộ chi tiết + thứ tự các bước

SAU (Facade gói lại sau một hàm):
  class MediaService {
    constructor(decoder, resizer, encoder, uploader) {
      Object.assign(this, { decoder, resizer, encoder, uploader });
    }
    async process(file) {
      const raw   = this.decoder.decode(file);
      const small = this.resizer.resize(raw, 720);
      const enc   = this.encoder.encode(small, "h264");
      return this.uploader.upload(enc);
    }
  }
  const url = await media.process(file);   // client chỉ gọi 1 hàm

GIẢI THÍCH TỪNG BƯỚC:
  1. Facade giấu độ phức tạp và thứ tự các bước bên trong.
  2. Client chỉ phụ thuộc MediaService, không phụ thuộc 4 module con
     -> đổi bên trong không ảnh hưởng client.
  3. Khác Adapter (đổi interface cho tương thích): Facade chỉ ĐƠN GIẢN HÓA.

VÍ DỤ THỰC TẾ: một SDK bọc nhiều API con; service layer gói nhiều
repository.'
,description_en=
'A Facade provides ONE simple interface hiding a complex subsystem (many
classes/steps).

BEFORE (the client must know and call many steps in the right order):
  const raw   = decoder.decode(file);
  const small = resizer.resize(raw, 720);
  const enc   = encoder.encode(small, "h264");
  const url   = uploader.upload(enc);
  // the client carries all the detail + step order

AFTER (a Facade wraps it behind one method):
  class MediaService {
    constructor(decoder, resizer, encoder, uploader) {
      Object.assign(this, { decoder, resizer, encoder, uploader });
    }
    async process(file) {
      const raw   = this.decoder.decode(file);
      const small = this.resizer.resize(raw, 720);
      const enc   = this.encoder.encode(small, "h264");
      return this.uploader.upload(enc);
    }
  }
  const url = await media.process(file);   // the client calls one method

STEP BY STEP:
  1. The facade hides the complexity and step order inside.
  2. The client depends only on MediaService, not the 4 submodules ->
     internal changes do not affect the client.
  3. Unlike Adapter (changes an interface for compatibility): a Facade
     just SIMPLIFIES.

REAL EXAMPLE: an SDK wrapping many sub-APIs; a service layer wrapping
several repositories.'
WHERE id='n_dp_facade';

UPDATE kg_nodes SET
description=
'Proxy đứng THAY object thật (cùng interface) để KIỂM SOÁT truy cập:
lazy load, cache, kiểm quyền, logging.

VÍ DỤ 1 — JS Proxy chặn field nhạy cảm + log đọc:
  const user = { name: "An", ssn: "123-45-6789" };
  const guarded = new Proxy(user, {
    get(target, key) {
      if (key === "ssn") throw new Error("Access denied: ssn");
      console.log("read", key);
      return target[key];
    },
  });
  guarded.name;   // log "read name" -> "An"
  guarded.ssn;    // ném lỗi Access denied

VÍ DỤ 2 — Virtual proxy (tạo object nặng KHI CẦN):
  class ReportProxy {
    #real;
    render() {
      if (!this.#real) this.#real = new HeavyReport();  // lazy
      return this.#real.render();
    }
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Proxy CÙNG interface với object thật -> client không phân biệt.
  2. Thêm lớp kiểm soát: quyền (protection), tạo lười (virtual), cache,
     gọi từ xa (remote proxy).
  3. Khác Decorator (thêm tính năng): Proxy tập trung KIỂM SOÁT truy cập.'
,description_en=
'A Proxy stands IN FOR the real object (same interface) to CONTROL access:
lazy loading, caching, permission checks, logging.

EXAMPLE 1 - a JS Proxy blocking a sensitive field + logging reads:
  const user = { name: "An", ssn: "123-45-6789" };
  const guarded = new Proxy(user, {
    get(target, key) {
      if (key === "ssn") throw new Error("Access denied: ssn");
      console.log("read", key);
      return target[key];
    },
  });
  guarded.name;   // logs "read name" -> "An"
  guarded.ssn;    // throws Access denied

EXAMPLE 2 - a Virtual proxy (create a heavy object ON DEMAND):
  class ReportProxy {
    #real;
    render() {
      if (!this.#real) this.#real = new HeavyReport();  // lazy
      return this.#real.render();
    }
  }

STEP BY STEP:
  1. The proxy has the SAME interface as the real object -> the client
     cannot tell the difference.
  2. Add a control layer: protection (permissions), virtual (lazy),
     caching, remote (remote proxy).
  3. Unlike Decorator (adds features): a Proxy focuses on CONTROLLING access.'
WHERE id='n_dp_proxy';
