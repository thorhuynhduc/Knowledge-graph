-- ===================================================================
--  BỔ SUNG: Node.js Core (chi tiết) — topic mới, tiếng Việt
--  Mô tả có ví dụ code, hard-wrap ~72 cột (modal dùng font monospace +
--  white-space:pre + cuộn ngang).
--  QUAN TRỌNG khi áp: PHẢI dùng --default-character-set=utf8mb4:
--    docker compose exec -T mysql \
--      mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--      "$DB_NAME" < seed_nodejs_core.sql
--  Idempotent (INSERT ... ON DUPLICATE KEY UPDATE) — chạy lại an toàn.
-- ===================================================================

-- ------------------------- NODES -----------------------------------
INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y) VALUES
-- Topic
('t_ndc','Node.js Core (Chi tiết)','Backend','Kiến thức chuyên sâu về nhân Node.js: Event Loop/libuv, module system, streams, EventEmitter, đa tiến trình & đa luồng, core modules, xử lý lỗi và V8/bộ nhớ. Mục tiêu là hiểu bản chất runtime để trả lời sâu khi phỏng vấn Senior.','[]',950,150),

-- Sections
('s_ndc_1','Event Loop & Bất đồng bộ','Backend','Cách Node xử lý I/O không chặn: kiến trúc runtime, các phase của event loop, micro/macrotask và cách tránh chặn luồng.','[]',600,300),
('s_ndc_2','Module System (CommonJS & ESM)','Backend','Hai hệ module của Node: cách nạp, cache, phân giải đường dẫn, và tương tác giữa CommonJS và ES Modules.','[]',1300,300),
('s_ndc_3','Streams & Buffer','Backend','Xử lý dữ liệu theo luồng để tiết kiệm bộ nhớ: các loại stream, backpressure, chế độ hoạt động và dữ liệu nhị phân Buffer.','[]',450,500),
('s_ndc_4','EventEmitter & Sự kiện','Backend','Mô hình phát/nghe sự kiện — nền tảng của nhiều API core (stream, http, process).','[]',1450,500),
('s_ndc_5','Process, Child Process & Cluster','Backend','Đối tượng process, tạo tiến trình con và nhân bản tiến trình để tận dụng nhiều CPU core.','[]',400,750),
('s_ndc_6','Worker Threads & Đa luồng','System Design','Chạy JS song song trong cùng tiến trình cho tác vụ CPU-bound; chia sẻ bộ nhớ an toàn.','[]',1500,750),
('s_ndc_7','Core Modules (fs, http, crypto...)','Backend','Các module lõi thường dùng và cách chúng tương tác với event loop/thread pool.','[]',600,950),
('s_ndc_8','Error Handling & Async Context','Backend','Phân loại lỗi, bắt lỗi trong async, xử lý lỗi toàn cục và truyền context xuyên chuỗi bất đồng bộ.','[]',1300,950),
('s_ndc_9','V8, Bộ nhớ & Hiệu năng','DevOps & Cloud','Engine V8, garbage collection, rò rỉ bộ nhớ và cách đo/tối ưu hiệu năng.','[]',950,1050),

-- ===== Section 1: Event Loop =====
('n_el_arch','Kiến trúc runtime: V8 + libuv','Backend',
'Node.js = V8 (máy ảo chạy JS, cùng engine với Chrome)
       + libuv (event loop + thread pool + I/O bất đồng bộ)
       + các C++ binding + thư viện core viết bằng JS.

Ở tầng JavaScript, code CỦA BẠN chạy trên MỘT luồng duy
nhất (main thread). Nhưng bên dưới, libuv có một thread
pool (mặc định 4 luồng) để làm việc blocking như đọc file,
DNS, crypto nặng.

Mô hình tổng quát:
  single-threaded event loop + non-blocking I/O

Ví dụ phân biệt luồng:
  const os = require("os");
  console.log(os.cpus().length);  // vd 8 core máy
  // nhưng code JS vẫn chỉ chạy trên 1 luồng; muốn dùng
  // hết core phải cluster / worker_threads

Vì thế Node rất hợp I/O-bound (API, mạng, DB) và cần kỹ
thuật riêng cho CPU-bound.','[]',500,180),

('n_el_phases','6 phase của Event Loop','Backend',
'Event loop lặp vô hạn qua các phase cố định, mỗi phase có
hàng đợi callback riêng:
  1. timers        - setTimeout / setInterval đến hạn
  2. pending cbs   - vài callback I/O hoãn từ vòng trước
  3. idle/prepare  - nội bộ
  4. poll          - nhận & chạy callback I/O (đọc socket)
  5. check         - setImmediate
  6. close cbs     - vd socket.on("close")

Giữa mỗi phase, Node xả hết microtask (nextTick rồi
Promise) mới đi tiếp.

Ví dụ thứ tự phase:
  const fs = require("fs");
  fs.readFile(__filename, () => {   // callback chạy ở poll
    setImmediate(() => console.log("check"));
    setTimeout(() => console.log("timers"), 0);
  });
  // In: check -> timers
  // vì sau poll là check, còn timers phải chờ vòng sau

Xem sâu ở node "Event loop chạy chi tiết một tick".','[]',620,180),

('n_el_micro_macro','Microtask vs Macrotask','Backend',
'Macrotask = callback trong các phase (timers, I/O,
setImmediate, close). Microtask = 2 hàng đợi ưu tiên cao,
chạy XEN GIỮA các macrotask:
  • process.nextTick queue        (ưu tiên 1)
  • Promise / queueMicrotask queue (ưu tiên 2)

Luật: sau mỗi macrotask, xả HẾT nextTick rồi HẾT Promise,
mới tới macrotask kế. Nên microtask luôn chạy trước
setTimeout dù timeout = 0.

Ví dụ:
  setTimeout(() => console.log("macro"), 0);
  Promise.resolve().then(() => console.log("micro"));
  process.nextTick(() => console.log("nextTick"));
  // In: nextTick -> micro -> macro

Bẫy: microtask sinh microtask được xả hết trong cùng lượt
-> chuỗi microtask quá dài có thể trì hoãn I/O.','[]',740,180),

('n_el_nexttick','process.nextTick vs setImmediate','Backend',
'Hai cách hoãn việc, khác nhau về thời điểm chạy:
  • process.nextTick(cb): chạy NGAY sau thao tác hiện tại,
    TRƯỚC khi event loop đi tiếp (microtask, ưu tiên còn
    cao hơn Promise).
  • setImmediate(cb): chạy ở phase check, tức LƯỢT sau,
    sau khi loop đã ghé qua poll (I/O).

Ví dụ:
  setImmediate(() => console.log("immediate"));
  process.nextTick(() => console.log("nextTick"));
  // In: nextTick -> immediate

Quy tắc dùng:
  • Cần chạy trước mọi thứ (vd phát lỗi đồng nhất) -> nextTick
  • Cần nhường I/O, lặp an toàn                    -> setImmediate

Lạm dụng nextTick đệ quy -> đói I/O (xem node starvation).','[]',500,240),

('n_el_timers','Timers & độ chính xác','Backend',
'setTimeout/setInterval KHÔNG chính xác tuyệt đối: chạy ở
phase timers và đảm bảo >= thời gian đặt, không đúng từng
ms (phụ thuộc tải event loop). setTimeout(fn,0) tối thiểu
thực chất ~1ms.

Ví dụ trễ hơn mong đợi:
  const t = Date.now();
  setTimeout(() => {
    console.log(Date.now() - t);  // có thể 5, 20... ms
  }, 0);
  for (let i = 0; i < 1e9; i++) {} // chặn loop -> timer trễ

Nhớ clearTimeout/clearInterval để tránh rò rỉ và tránh giữ
tiến trình sống ngoài ý muốn.

Timer dạng Promise:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(1000);','[]',620,240),

('n_el_blocking','Chặn Event Loop & cách tránh','Backend',
'Việc CPU nặng chạy trên luồng JS sẽ CHẶN mọi request khác
(chỉ có 1 luồng). Thủ phạm: vòng lặp lớn, JSON.parse chuỗi
khổng lồ, crypto đồng bộ, regex catastrophic backtracking,
đọc cả file lớn vào RAM.

Ví dụ CHẶN (xấu):
  app.get("/hash", (req, res) => {
    const h = crypto.pbkdf2Sync(pw, salt, 1e6, 64, "sha512");
    res.send(h);   // mọi request khác đứng chờ tại đây
  });

Cách tránh:
  • Dùng bản async (pbkdf2 thay vì pbkdf2Sync) -> thread pool
  • Đẩy tính toán sang Worker Threads
  • Chia nhỏ tác vụ bằng setImmediate
  • Dùng stream thay vì đọc hết file

Đo độ trễ loop: perf_hooks.monitorEventLoopDelay().','[]',740,240),

-- ===== Section 2: Modules =====
('n_mod_cjs','CommonJS: require & module.exports','Backend',
'CommonJS (CJS) nạp module ĐỒNG BỘ; require() trả về
module.exports. Lưu ý: exports chỉ là alias trỏ tới
module.exports — gán lại nguyên exports sẽ mất tác dụng.

Ví dụ:
  // math.js
  function add(a, b) { return a + b; }
  module.exports = { add };     // ĐÚNG
  // exports = { add };         // SAI: mất liên kết

  // app.js
  const { add } = require("./math");
  console.log(add(2, 3));       // 5

Circular dependency: require trả về phần exports CHƯA hoàn
chỉnh tại thời điểm gọi -> có thể nhận undefined nếu dùng
quá sớm.','[]',1200,180),

('n_mod_wrapper','Module wrapper & biến module','Backend',
'Mỗi file CJS được Node BỌC trong một hàm trước khi chạy:
  (function (exports, require, module, __filename, __dirname) {
     // code của bạn ở đây
  });

Nhờ vậy: biến khai báo trong file là CỤC BỘ (không rơi vào
global) và luôn có sẵn 5 tham số trên.

Ví dụ:
  console.log(__dirname);   // thư mục chứa file
  console.log(__filename);  // đường dẫn đầy đủ của file
  // ở cấp module CJS: this === module.exports

Đây là lý do không cần tự viết IIFE để tránh rò biến ra
global như khi dùng thẻ <script> trên trình duyệt.','[]',1320,180),

('n_mod_resolution','Thuật toán phân giải module','Backend',
'require("x") tìm theo thứ tự:
  1. Core module? ("fs","path"...) -> dùng luôn
  2. Bắt đầu "./" hay "../" -> file/thư mục tương đối
  3. Còn lại -> tìm trong node_modules, đi NGƯỢC lên các
     thư mục cha cho tới gốc
  4. Trong package: đọc package.json (main / exports);
     nếu là thư mục thì thử index.js
  Đuôi thử lần lượt: .js -> .json -> .node

Ví dụ node_modules lookup — /app/src/a.js gọi require("lodash"):
  tìm /app/src/node_modules/lodash
      /app/node_modules/lodash     <- thấy ở đây
      /node_modules/lodash

Module đã nạp được cache trong require.cache theo đường dẫn
tuyệt đối -> require lần 2 KHÔNG chạy lại file.','[]',1440,180),

('n_mod_esm','ES Modules trong Node','Backend',
'ES Modules (ESM) kích hoạt bằng đuôi .mjs hoặc
"type":"module" trong package.json. import/export TĨNH, nạp
BẤT ĐỒNG BỘ, hỗ trợ top-level await.

Ví dụ:
  // math.mjs
  export function add(a, b) { return a + b; }
  export default 42;

  // app.mjs
  import answer, { add } from "./math.mjs";
  const res = await fetch(url);   // top-level await OK

Khác CJS:
  • Không có __dirname/__filename; thay bằng:
      import { fileURLToPath } from "url";
      const __filename = fileURLToPath(import.meta.url);
  • import là live binding (thấy giá trị export cập nhật)
  • Phân tích tĩnh -> hỗ trợ tree-shaking
  • Luôn ở strict mode','[]',1200,240),

('n_mod_interop','Interop CommonJS ↔ ESM','Backend',
'ESM và CJS làm việc với nhau nhưng KHÔNG đối xứng:
  • ESM import CJS: ĐƯỢC. default = module.exports.
      import pkg from "cjs-lib";
      const { foo } = pkg;   // named đôi khi không tách được
  • CJS require ESM: KHÔNG trực tiếp (ESM bất đồng bộ).
    Phải dùng import động:
      const esm = await import("./mod.mjs");

import() động trả Promise, dùng được ở cả CJS lẫn ESM và
cho phép nạp lười (lazy):
  if (cond) {
    const { heavy } = await import("./heavy.js");
  }

Lưu ý: trong ESM không có require/module/exports mặc định.','[]',1440,240),

-- ===== Section 3: Streams & Buffer =====
('n_stream_types','4 loại Stream','Backend',
'Stream xử lý dữ liệu theo từng CHUNK -> không cần nạp cả
file vào RAM. 4 loại:
  • Readable  - nguồn đọc: fs.createReadStream, req
  • Writable  - đích ghi: res, fs.createWriteStream
  • Duplex    - hai chiều: TCP socket
  • Transform - Duplex biến đổi dữ liệu: zlib.gzip, crypto

Ví dụ copy file mà không ngốn RAM dù file 10GB:
  const fs = require("fs");
  fs.createReadStream("big.mp4")
    .pipe(fs.createWriteStream("copy.mp4"));

So với đọc hết một lần (ngốn RAM, có thể sập tiến trình):
  const data = fs.readFileSync("big.mp4"); // nạp cả 10GB

Stream là nền của HTTP, file, nén, mã hoá trong Node.','[]',350,440),

('n_stream_backpressure','Backpressure & pipeline','Backend',
'Backpressure = cơ chế ghìm khi bên GHI chậm hơn bên ĐỌC,
để dữ liệu không dồn vô hạn trong bộ nhớ.

Cơ chế: write() trả false khi buffer nội bộ (highWaterMark)
đầy -> nên dừng đọc, chờ sự kiện "drain" mới ghi tiếp.
pipe() và pipeline() TỰ xử lý việc này.

Ví dụ nên dùng pipeline (tự xử lý lỗi + đóng tài nguyên):
  const { pipeline } = require("stream/promises");
  const fs = require("fs");
  const zlib = require("zlib");
  await pipeline(
    fs.createReadStream("in.txt"),
    zlib.createGzip(),
    fs.createWriteStream("in.txt.gz")
  );

Tránh nối pipe() thủ công nhiều tầng vì dễ rò tài nguyên
khi có lỗi giữa chừng.','[]',470,440),

('n_stream_modes','Flowing vs Paused mode','Backend',
'Readable có 2 chế độ đọc:
  • paused  - chủ động gọi .read()
  • flowing - dữ liệu tự chảy qua sự kiện "data"
Gắn listener "data" hoặc gọi .pipe()/.resume() -> chuyển
sang flowing; .pause() -> quay lại paused.

Ví dụ flowing:
  rs.on("data", chunk => console.log(chunk.length));
  rs.on("end",  () => console.log("xong"));

objectMode - cho phép stream truyền object thay vì chỉ
Buffer/string:
  const { Readable } = require("stream");
  Readable.from([{ a: 1 }, { a: 2 }])
    .on("data", o => console.log(o.a));   // 1, 2','[]',350,560),

('n_buffer','Buffer & dữ liệu nhị phân','Backend',
'Buffer là vùng nhớ nhị phân cố định NẰM NGOÀI heap V8, đại
diện một dãy byte. Là lớp con của Uint8Array.

Tạo Buffer:
  Buffer.alloc(8);            // 8 byte, zero-filled (an toàn)
  Buffer.allocUnsafe(8);      // nhanh hơn, có thể chứa rác
  Buffer.from("hi", "utf8");  // từ chuỗi

Chuyển đổi encoding:
  const b = Buffer.from("Xin chào");
  b.toString("utf8");    // "Xin chào"
  b.toString("hex");     // vd "58696e..."
  b.toString("base64");

Dùng cho file, network, crypto — nơi làm việc với byte thô
thay vì text.','[]',470,560),

-- ===== Section 4: EventEmitter =====
('n_ee_basic','EventEmitter cơ bản','Backend',
'EventEmitter là nền của mô hình sự kiện trong Node; nhiều
đối tượng core kế thừa nó (stream, http.Server, process).

Ví dụ:
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("order", (id) => console.log("Xử lý đơn", id));
  bus.once("boot", () => console.log("chạy 1 lần"));
  bus.emit("order", 101);  // emit ĐỒNG BỘ -> gọi listener ngay

API chính: on/addListener, once, emit, off/removeListener.

Sự kiện "error" đặc biệt: nếu emit "error" mà KHÔNG có
listener nào -> Node throw và crash:
  bus.on("error", err => console.error(err)); // nên luôn có','[]',1350,440),

('n_ee_leak','Memory leak & maxListeners','Backend',
'emit là ĐỒNG BỘ, gọi các listener tuần tự -> listener nặng
sẽ chặn luồng.

Node cảnh báo khi một sự kiện có > 10 listener
(MaxListenersExceededWarning) — thường do quên gỡ listener:
  emitter.setMaxListeners(20);        // nâng ngưỡng nếu cần
  emitter.removeListener("data", fn); // nhớ gỡ khi xong

Dùng với async:
  const { once, on } = require("events");
  await once(emitter, "ready");       // chờ sự kiện bằng Promise
  for await (const [msg] of on(emitter, "data")) { /* ... */ }

Rò rỉ listener là nguyên nhân memory leak phổ biến trong
app chạy lâu (xem node Memory leak).','[]',1550,440),

-- ===== Section 5: Process / Cluster =====
('n_process_obj','Đối tượng process','Backend',
'process là global đại diện tiến trình Node hiện tại.
Thuộc tính/hàm hay dùng:
  process.argv            // tham số dòng lệnh
  process.env             // biến môi trường
  process.pid             // id tiến trình
  process.cwd()           // thư mục làm việc
  process.memoryUsage()   // { rss, heapUsed, ... }
  process.hrtime.bigint() // đo thời gian nano giây

Ví dụ đọc arg + env — chạy: node app.js --port 4000
  const port = process.env.PORT || 3000;
  console.log(process.argv.slice(2)); // ["--port","4000"]

Sự kiện vòng đời:
  process.on("exit", code => console.log("thoát", code));','[]',300,690),

('n_child_process','child_process: spawn/exec/fork','Backend',
'Tạo tiến trình con để chạy lệnh hệ thống hoặc tách việc
nặng. 4 API chính:
  • spawn    - stream I/O, tốt cho output lớn
  • exec     - chạy qua shell, buffer toàn bộ output
  • execFile - như exec nhưng KHÔNG qua shell (an toàn hơn)
  • fork     - tạo tiến trình Node con + kênh IPC

Ví dụ spawn:
  const { spawn } = require("child_process");
  const ls = spawn("ls", ["-la"]);
  ls.stdout.on("data", d => console.log(String(d)));

Ví dụ fork (giao tiếp 2 chiều qua message):
  const child = fork("worker.js");
  child.send({ job: 1 });
  child.on("message", m => console.log("kết quả", m));

Ưu tiên execFile/spawn (không shell) để tránh shell
injection khi có input người dùng.','[]',420,690),

('n_cluster','Cluster module','Backend',
'cluster nhân bản tiến trình Node (worker) để tận dụng
NHIỀU CPU core; master phân phối kết nối trên CÙNG một cổng.

Ví dụ:
  const cluster = require("cluster");
  const os = require("os");
  if (cluster.isPrimary) {
    for (let i = 0; i < os.cpus().length; i++) cluster.fork();
  } else {
    require("./server.js");   // mỗi worker chạy server
  }

Lưu ý:
  • Mỗi worker là 1 PROCESS riêng, bộ nhớ TÁCH BIỆT -> state
    dùng chung (session, cache) phải để ngoài (Redis).
  • Thực tế thường dùng PM2: pm2 start app.js -i max
    (lớp bọc tiện dụng quanh cluster).

So với worker_threads: cluster hợp scale I/O/HTTP.','[]',300,810),

('n_signals','Signals & Graceful shutdown','Backend',
'Graceful shutdown = tắt server êm khi nhận tín hiệu dừng
(SIGTERM khi Docker/K8s rolling update, SIGINT khi Ctrl+C)
để không cắt ngang request đang chạy.

Ví dụ:
  const server = app.listen(3000);
  function shutdown() {
    server.close(() => {   // ngừng nhận kết nối mới
      db.end();            // đóng DB
      process.exit(0);
    });
    setTimeout(() => process.exit(1), 10000); // ép thoát nếu treo
  }
  process.on("SIGTERM", shutdown);
  process.on("SIGINT", shutdown);

Thiếu bước này -> deploy sẽ ngắt đột ngột các request đang
xử lý, gây lỗi cho người dùng.','[]',420,810),

-- ===== Section 6: Worker Threads =====
('n_worker_threads','worker_threads','System Design',
'worker_threads chạy JS SONG SONG trên nhiều luồng trong
CÙNG tiến trình -> dành cho việc CPU-bound (mã hoá, xử lý
ảnh, tính toán) mà không chặn luồng chính.

Ví dụ:
  // main.js
  const { Worker } = require("worker_threads");
  const w = new Worker("./calc.js", { workerData: 40 });
  w.on("message", r => console.log("fib =", r));

  // calc.js
  const { parentPort, workerData } = require("worker_threads");
  function fib(n) { return n < 2 ? n : fib(n-1) + fib(n-2); }
  parentPort.postMessage(fib(workerData));

Mỗi worker có V8 + event loop riêng. Giao tiếp qua
postMessage (structured clone) hoặc SharedArrayBuffer.
Khác cluster: worker chia sẻ được bộ nhớ, nhẹ hơn process.','[]',1400,690),

('n_shared_mem','SharedArrayBuffer & Atomics','System Design',
'Mặc định dữ liệu gửi giữa các worker bị COPY (structured
clone). SharedArrayBuffer cho phép nhiều worker cùng đọc/
ghi MỘT vùng nhớ mà không copy -> hiệu năng cao.

Atomics đảm bảo thao tác nguyên tử + đồng bộ, tránh race
condition:
  const sab = new SharedArrayBuffer(4);
  const arr = new Int32Array(sab);
  Atomics.add(arr, 0, 5);   // cộng nguyên tử
  Atomics.load(arr, 0);     // đọc an toàn
  // Atomics.wait / notify: đồng bộ giữa các luồng

Truyền sab cho worker qua workerData/postMessage; mọi luồng
thấy cùng dữ liệu. Dùng cho bộ đếm, hàng đợi, dữ liệu số
chia sẻ giữa các luồng.','[]',1520,690),

('n_worker_vs_cluster','Worker Threads vs Cluster vs Child Process','System Design',
'Ba cách tách việc, chọn theo bài toán:

  worker_threads - đa LUỒNG trong 1 process, CHIA SẺ bộ nhớ,
    nhẹ.  -> việc CPU-bound (tính toán, mã hoá, xử lý ảnh).

  cluster - nhiều PROCESS cùng nghe 1 cổng, bộ nhớ tách
    biệt.  -> scale HTTP/I/O trên nhiều core (thường qua PM2).

  child_process - chạy chương trình/độc lập, cách ly hoàn
    toàn.  -> gọi lệnh hệ thống, chạy script bên ngoài.

Quy tắc nhanh:
  • Tính toán nặng             -> worker_threads
  • Phục vụ nhiều request/core -> cluster (hoặc PM2)
  • Gọi tool/lệnh bên ngoài    -> child_process','[]',1400,810),

-- ===== Section 7: Core Modules =====
('n_fs','fs — hệ thống file','Backend',
'Module fs có 3 kiểu API:
  • Đồng bộ:  fs.readFileSync (CHẶN loop; chỉ dùng lúc khởi
    động hoặc script nhỏ)
  • Callback: fs.readFile(path, cb) (err-first)
  • Promise:  fs.promises (nên dùng với async/await)

Ví dụ:
  const fs = require("fs/promises");
  const data = await fs.readFile("config.json", "utf8");
  await fs.writeFile("out.txt", "hello");

File lớn -> dùng stream thay vì đọc cả file:
  const fss = require("fs");
  fss.createReadStream("big.log").pipe(process.stdout);

Các thao tác fs chạy trên THREAD POOL của libuv (giới hạn
UV_THREADPOOL_SIZE). fs.watch theo dõi thay đổi file.','[]',500,890),

('n_http','http / https / net','Backend',
'Module http tạo server và client HTTP. req là Readable
stream, res là Writable stream.

Server:
  const http = require("http");
  http.createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true }));
  }).listen(3000);

Client:
  http.get("http://api.local/ping", res => {
    let body = "";
    res.on("data", c => body += c);
    res.on("end", () => console.log(body));
  });

Express/Fastify xây trên http. net là tầng TCP thấp hơn;
http2 hỗ trợ multiplexing. Agent quản lý pool kết nối
(keep-alive) để tái dùng, giảm chi phí bắt tay TCP.','[]',620,890),

('n_crypto','crypto','Backend',
'crypto cung cấp hàm mã hoá/băm chuẩn — KHÔNG tự chế thuật
toán.

Băm (hash) và sinh ngẫu nhiên:
  const crypto = require("crypto");
  crypto.createHash("sha256").update("abc").digest("hex");
  crypto.randomUUID();                  // id ngẫu nhiên
  crypto.randomBytes(16).toString("hex");

Băm mật khẩu — dùng bản ASYNC vì nặng (chạy trên thread pool):
  crypto.scrypt(pw, salt, 64, (err, key) => { /* ... */ });
  // TRÁNH scryptSync trong request -> chặn loop

Ngoài ra: HMAC, mã hoá đối xứng (createCipheriv), ký/verify
bất đối xứng. Dùng randomBytes/randomUUID cho token; KHÔNG
dùng Math.random (không an toàn mật mã).','[]',500,1010),

('n_path_os','path, os, url','Backend',
'Nhóm module tiện ích đa nền tảng.

path — xử lý đường dẫn đúng trên cả Windows lẫn Linux:
  const path = require("path");
  path.join("a", "b", "c.txt");   // "a/b/c.txt"
  path.resolve("src", "app.js");  // đường dẫn tuyệt đối
  path.extname("a.png");          // ".png"
  path.basename("/x/y.txt");      // "y.txt"

os — thông tin hệ thống:
  const os = require("os");
  os.cpus().length;   // số core
  os.totalmem();      // tổng RAM
  os.platform();      // "linux" | "win32" | "darwin"

URL / URLSearchParams để phân tích & dựng URL. Luôn dùng
path.join thay vì tự nối chuỗi "/".','[]',620,1010),

('n_util','util & module tiện ích','Backend',
'util và vài module tiện ích hay dùng khi hiện đại hoá code.

util.promisify — biến hàm callback (err-first) thành Promise:
  const util = require("util");
  const fs = require("fs");
  const readFile = util.promisify(fs.readFile);
  const data = await readFile("a.txt", "utf8");

util.inspect — log object sâu, có màu:
  console.log(util.inspect(obj, { depth: null, colors: true }));

zlib — nén/giải nén (là Transform stream):
  const zlib = require("zlib");
  readable.pipe(zlib.createGzip()).pipe(writable);

timers/promises — setTimeout dạng Promise:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(500);','[]',560,950),

-- ===== Section 8: Error Handling =====
('n_err_types','Operational vs Programmer errors','Backend',
'Phân loại lỗi để quyết định XỬ LÝ hay CRASH:

  • Operational error - lỗi vận hành DỰ ĐOÁN được: mất kết
    nối DB, timeout, input sai, hết dung lượng.
    -> nên bắt, log, retry hoặc trả lỗi cho client.
  • Programmer error - BUG trong code: gọi hàm trên
    undefined, quên await, sai kiểu.
    -> nên để tiến trình CRASH và restart sạch (fail fast),
       vì state đã không còn tin cậy.

Ví dụ:
  // operational: xử lý được
  try { await db.query(sql); }
  catch (e) { logger.warn(e); return res.status(503).end(); }

  // programmer: đừng nuốt, hãy sửa bug
  user.nmae;  // typo -> undefined, lỗi logic ngầm

Nuốt hết mọi lỗi khiến bug bị giấu và app chạy trong trạng
thái hỏng.','[]',1200,890),

('n_err_async','Bắt lỗi trong async','Backend',
'Cách bắt lỗi tuỳ kiểu bất đồng bộ:

  • async/await -> try/catch:
      try { const u = await getUser(id); }
      catch (e) { handle(e); }

  • Promise -> .catch():
      getUser(id).then(use).catch(handle);

  • Callback err-first -> kiểm tra tham số đầu:
      fs.readFile(p, (err, data) => {
        if (err) return handle(err);
      });

Bẫy hay gặp: QUÊN await -> lỗi thành unhandledRejection:
  async function f() { doAsync(); }  // thiếu await/return

Express 4: handler async phải next(err) hoặc dùng wrapper;
Express 5 tự bắt Promise reject.
Song song: Promise.all (fail-fast) vs Promise.allSettled
(trả về mọi kết quả kể cả lỗi).','[]',1320,890),

('n_err_global','uncaughtException & unhandledRejection','Backend',
'Hai lưới an toàn cuối cùng cho lỗi không bắt được:

  process.on("uncaughtException", err => {
    logger.fatal(err);
    process.exit(1);   // NÊN thoát: state không còn tin cậy
  });
  process.on("unhandledRejection", reason => {
    logger.error(reason);
    process.exit(1);
  });

• uncaughtException: lỗi đồng bộ không được try/catch.
• unhandledRejection: Promise reject không có .catch
  (từ Node 15 mặc định làm crash tiến trình).

Triết lý: đừng dùng chúng để "chạy tiếp như chưa có gì".
Hãy log rồi để process manager (PM2 / Kubernetes) restart
tiến trình sạch — an toàn hơn là cố phục hồi.','[]',1200,950),

('n_als','AsyncLocalStorage','Backend',
'AsyncLocalStorage lưu context xuyên suốt một chuỗi bất
đồng bộ mà KHÔNG phải truyền tham số thủ công qua từng hàm
— giống thread-local storage. Xây trên async_hooks.

Ví dụ gắn correlation id cho mỗi request để log:
  const { AsyncLocalStorage } = require("async_hooks");
  const als = new AsyncLocalStorage();

  app.use((req, res, next) => {
    als.run({ reqId: crypto.randomUUID() }, () => next());
  });

  function log(msg) {
    const store = als.getStore();
    console.log(`[${store?.reqId}] ${msg}`);
  }
  // mọi hàm await sâu bên trong vẫn thấy đúng reqId

Dùng cho logging tương quan, tracing, multi-tenant. Có chút
chi phí hiệu năng nhưng thường chấp nhận được.','[]',1320,950),

-- ===== Section 9: V8 & Memory =====
('n_v8','V8 & biên dịch JIT','DevOps & Cloud',
'V8 là engine chạy JS của Node (cùng engine với Chrome).
Quy trình biên dịch:
  mã JS -> parse (AST) -> bytecode (Ignition)
        -> mã máy tối ưu (TurboFan) cho đoạn code NÓNG
        -> có thể de-optimize khi kiểu dữ liệu đổi bất ngờ

Mẹo giúp V8 tối ưu (giữ hidden class ổn định):
  // TỐT: hình dạng object nhất quán
  function P(x, y) { this.x = x; this.y = y; }
  const p = new P(1, 2);
  // XẤU: thêm field sau đó -> đổi shape -> chậm hơn
  p.z = 3;

Hệ quả thực tế: khởi tạo object cùng thứ tự field, tránh
đổi kiểu biến, tránh delete property trong vòng lặp nóng.
Cờ tinh chỉnh: node --v8-options.','[]',850,1010),

('n_gc','Garbage Collection & Heap','DevOps & Cloud',
'V8 gom rác (GC) theo THẾ HỆ vì đa số object chết trẻ:
  • Young generation - object mới; thu bằng Scavenger,
    nhanh, chạy thường xuyên.
  • Old generation   - object sống lâu; thu bằng
    Mark-Sweep-Compact, chậm hơn.
GC gây dừng luồng (stop-the-world) trong thời gian ngắn.

Heap có GIỚI HẠN mặc định (~vài GB tuỳ phiên bản), chỉnh:
  node --max-old-space-size=4096 app.js   // 4GB

Ví dụ chủ động (chỉ khi chạy với --expose-gc, dùng để test):
  if (global.gc) global.gc();

Object còn được tham chiếu thì KHÔNG bị thu -> giữ tham
chiếu ngoài ý muốn chính là memory leak (xem node kế).','[]',970,1010),

('n_memory','Memory leak & chẩn đoán','DevOps & Cloud',
'Memory leak trong app chạy lâu: heap tăng dần rồi OOM.
Nguyên nhân phổ biến:
  • biến/global tích luỹ (cache không giới hạn)
  • listener EventEmitter không gỡ
  • closure giữ tham chiếu lớn
  • timer (setInterval) không clear

Ví dụ leak điển hình:
  const cache = {};
  app.get("/u/:id", (req, res) => {
    cache[req.params.id] = bigObject;  // không bao giờ xoá
  });                                   // -> phình mãi

Phát hiện:
  console.log(process.memoryUsage().heapUsed); // theo dõi tăng
  // chụp heap snapshot: node --inspect + Chrome DevTools
  // hoặc cờ --heapsnapshot-near-heap-limit

Giải pháp cache: dùng LRU có giới hạn kích thước.','[]',850,1070),

('n_perf','Đo hiệu năng: perf_hooks & profiling','DevOps & Cloud',
'Đo TRƯỚC khi tối ưu — đừng đoán. Công cụ tích hợp:

perf_hooks — đo thời gian & độ trễ event loop:
  const { performance, monitorEventLoopDelay } =
    require("perf_hooks");
  const t = performance.now();
  doWork();
  console.log(performance.now() - t, "ms");

  const h = monitorEventLoopDelay(); h.enable();
  // sau một lúc: h.mean, h.max -> độ trễ loop (ns)

Profiling CPU:
  node --prof app.js     // sinh isolate log để phân tích
  node --inspect app.js  // gắn Chrome DevTools
  // hoặc clinic.js, 0x (vẽ flamegraph)

Quy trình: đo -> tìm điểm nóng thật -> tối ưu đúng chỗ ->
đo lại để xác nhận.','[]',970,1070)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), links=VALUES(links);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_ndc_part-of','root','t_ndc','part-of'),
('e_t_ndc_t_nodejs_related','t_ndc','t_nodejs','related'),
('e_t_ndc_s_ndc_1_part-of','t_ndc','s_ndc_1','part-of'),
('e_t_ndc_s_ndc_2_part-of','t_ndc','s_ndc_2','part-of'),
('e_t_ndc_s_ndc_3_part-of','t_ndc','s_ndc_3','part-of'),
('e_t_ndc_s_ndc_4_part-of','t_ndc','s_ndc_4','part-of'),
('e_t_ndc_s_ndc_5_part-of','t_ndc','s_ndc_5','part-of'),
('e_t_ndc_s_ndc_6_part-of','t_ndc','s_ndc_6','part-of'),
('e_t_ndc_s_ndc_7_part-of','t_ndc','s_ndc_7','part-of'),
('e_t_ndc_s_ndc_8_part-of','t_ndc','s_ndc_8','part-of'),
('e_t_ndc_s_ndc_9_part-of','t_ndc','s_ndc_9','part-of'),
('e_s_ndc_1_n_el_arch_part-of','s_ndc_1','n_el_arch','part-of'),
('e_s_ndc_1_n_el_phases_part-of','s_ndc_1','n_el_phases','part-of'),
('e_s_ndc_1_n_el_micro_macro_part-of','s_ndc_1','n_el_micro_macro','part-of'),
('e_s_ndc_1_n_el_nexttick_part-of','s_ndc_1','n_el_nexttick','part-of'),
('e_s_ndc_1_n_el_timers_part-of','s_ndc_1','n_el_timers','part-of'),
('e_s_ndc_1_n_el_blocking_part-of','s_ndc_1','n_el_blocking','part-of'),
('e_s_ndc_2_n_mod_cjs_part-of','s_ndc_2','n_mod_cjs','part-of'),
('e_s_ndc_2_n_mod_wrapper_part-of','s_ndc_2','n_mod_wrapper','part-of'),
('e_s_ndc_2_n_mod_resolution_part-of','s_ndc_2','n_mod_resolution','part-of'),
('e_s_ndc_2_n_mod_esm_part-of','s_ndc_2','n_mod_esm','part-of'),
('e_s_ndc_2_n_mod_interop_part-of','s_ndc_2','n_mod_interop','part-of'),
('e_s_ndc_3_n_stream_types_part-of','s_ndc_3','n_stream_types','part-of'),
('e_s_ndc_3_n_stream_backpressure_part-of','s_ndc_3','n_stream_backpressure','part-of'),
('e_s_ndc_3_n_stream_modes_part-of','s_ndc_3','n_stream_modes','part-of'),
('e_s_ndc_3_n_buffer_part-of','s_ndc_3','n_buffer','part-of'),
('e_s_ndc_4_n_ee_basic_part-of','s_ndc_4','n_ee_basic','part-of'),
('e_s_ndc_4_n_ee_leak_part-of','s_ndc_4','n_ee_leak','part-of'),
('e_s_ndc_5_n_process_obj_part-of','s_ndc_5','n_process_obj','part-of'),
('e_s_ndc_5_n_child_process_part-of','s_ndc_5','n_child_process','part-of'),
('e_s_ndc_5_n_cluster_part-of','s_ndc_5','n_cluster','part-of'),
('e_s_ndc_5_n_signals_part-of','s_ndc_5','n_signals','part-of'),
('e_s_ndc_6_n_worker_threads_part-of','s_ndc_6','n_worker_threads','part-of'),
('e_s_ndc_6_n_shared_mem_part-of','s_ndc_6','n_shared_mem','part-of'),
('e_s_ndc_6_n_worker_vs_cluster_part-of','s_ndc_6','n_worker_vs_cluster','part-of'),
('e_s_ndc_7_n_fs_part-of','s_ndc_7','n_fs','part-of'),
('e_s_ndc_7_n_http_part-of','s_ndc_7','n_http','part-of'),
('e_s_ndc_7_n_crypto_part-of','s_ndc_7','n_crypto','part-of'),
('e_s_ndc_7_n_path_os_part-of','s_ndc_7','n_path_os','part-of'),
('e_s_ndc_7_n_util_part-of','s_ndc_7','n_util','part-of'),
('e_s_ndc_8_n_err_types_part-of','s_ndc_8','n_err_types','part-of'),
('e_s_ndc_8_n_err_async_part-of','s_ndc_8','n_err_async','part-of'),
('e_s_ndc_8_n_err_global_part-of','s_ndc_8','n_err_global','part-of'),
('e_s_ndc_8_n_als_part-of','s_ndc_8','n_als','part-of'),
('e_s_ndc_9_n_v8_part-of','s_ndc_9','n_v8','part-of'),
('e_s_ndc_9_n_gc_part-of','s_ndc_9','n_gc','part-of'),
('e_s_ndc_9_n_memory_part-of','s_ndc_9','n_memory','part-of'),
('e_s_ndc_9_n_perf_part-of','s_ndc_9','n_perf','part-of'),
('e_n_el_phases_q_1_related','n_el_phases','q_1','related'),
('e_n_mod_cjs_q_4_related','n_mod_cjs','q_4','related'),
('e_n_err_async_q_3_related','n_err_async','q_3','related'),
('e_n_el_blocking_q_11_related','n_el_blocking','q_11','related'),
('e_n_cluster_q_11_related','n_cluster','q_11','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
