-- ===================================================================
--  BỔ SUNG NÂNG CAO: Event Loop / libuv / Vòng đời request (deep dive)
--  Câu trả lời CHI TIẾT + sơ đồ. Prose hard-wrap ~70 cột (modal dùng
--  font monospace + white-space:pre + cuộn ngang).
--  QUAN TRỌNG khi áp: PHẢI dùng --default-character-set=utf8mb4:
--    docker compose exec -T mysql \
--      mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--      "$DB_NAME" < seed_nodejs_advanced.sql
--  Idempotent (INSERT ... ON DUPLICATE KEY UPDATE) — chạy lại an toàn.
-- ===================================================================

-- ------------------------- NODES -----------------------------------
INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y) VALUES
('s_ndc_10','Deep Dive: Event Loop & libuv','Backend','Đào sâu cơ chế bên dưới kèm sơ đồ: libuv là gì và hoạt động ra sao, event loop chạy từng tick thế nào, phân biệt event loop với các queue, poll phase, thread pool, non-blocking I/O ở tầng OS và ý nghĩa "single-threaded".','[]',750,300),
('s_ndc_11','Deep Dive: Vòng đời request & Thứ tự thực thi','Backend','Trace một HTTP request từ kernel tới response, và thứ tự thực thi chính xác giữa nextTick, Promise microtask, timers và I/O — kèm sơ đồ, ví dụ code và các bẫy thường gặp.','[]',1150,300),

-- ===== Section 10: Event Loop & libuv (internals) =====
('n_dd_libuv','libuv là gì và hoạt động thế nào?','Backend',
'libuv là một thư viện C đa nền tảng, cung cấp EVENT LOOP và
I/O bất đồng bộ cho Node.js. Vai trò cốt lõi: che giấu sự
khác biệt của cơ chế I/O ở từng hệ điều hành sau MỘT API
chung — nó bọc epoll (Linux), kqueue (macOS/BSD), IOCP
(Windows).

SƠ ĐỒ — khi bạn gọi một API bất đồng bộ:

  Code JS của bạn (chạy trên V8, 1 luồng)
    │  ví dụ: fs.readFile(), db.query(), crypto.pbkdf2()
    ▼
  Node.js C++ bindings
    │
    ▼
  libuv  ── chia việc thành 2 hướng:
    │
    ├─► EVENT LOOP (luồng chính)
    │     • dùng cho I/O MẠNG (TCP/UDP/pipe)
    │     • qua epoll / kqueue / IOCP
    │     • 1 luồng theo dõi hàng nghìn socket
    │
    └─► THREAD POOL (mặc định 4 luồng)
          • cho việc KHÔNG có async ở kernel:
            fs.* (file), dns.lookup,
            crypto nặng (pbkdf2/scrypt), zlib
          • chạy blocking ở luồng phụ rồi
            trả kết quả ngược về event loop

ĐIỂM MẤU CHỐT (hay bị hiểu sai):
• I/O mạng KHÔNG dùng thread pool. libuv dùng trực tiếp
  socket non-blocking + epoll của kernel, chỉ bằng ĐÚNG
  MỘT luồng.
• Chỉ file I/O, DNS lookup, crypto nặng, zlib mới bị đẩy
  sang thread pool — vì trên đa số OS chúng không có API
  bất đồng bộ thật ở tầng kernel.

Chỉnh số luồng pool bằng biến môi trường UV_THREADPOOL_SIZE
(đặt TRƯỚC khi Node khởi động, tối đa 1024).','[]',650,180),

('n_dd_eventloop_detail','Event loop chạy chi tiết một vòng (tick) như thế nào?','Backend',
'Event loop là vòng lặp vô hạn do libuv chạy trên luồng
chính. Mỗi lần lặp gọi là một TICK, đi qua các phase theo
thứ tự CỐ ĐỊNH; mỗi phase có một hàng đợi callback riêng
(FIFO).

SƠ ĐỒ một tick:

  ┌─► (1) timers        → cb setTimeout/setInterval đến hạn
  │   (2) pending cbs   → vài callback I/O hoãn từ vòng trước
  │   (3) idle/prepare  → nội bộ libuv
  │   (4) poll   ★★★    → lấy sự kiện I/O từ kernel,
  │                       chạy callback I/O (đọc socket...)
  │   (5) check         → callback setImmediate
  │   (6) close cbs     → ví dụ socket.on("close")
  │        │
  └────────┘  hết phase 6 thì quay lại phase 1 (tick mới)

  ⚡ Sau MỖI callback và giữa MỖI phase, Node xả microtask:
       1. nextTick queue   → xả cho tới RỖNG
       2. Promise queue    → xả cho tới RỖNG
     rồi mới chạy callback / phase tiếp theo.

Ý nghĩa từng phase:
• timers: kiểm tra đồng hồ, chạy các timer đã quá hạn.
• pending callbacks: một số lỗi/hoàn tất I/O của hệ thống
  bị hoãn (ví dụ ECONNREFUSED của TCP).
• poll: trái tim của loop — chạy callback I/O đã sẵn sàng
  và quyết định có ngủ chờ I/O hay không.
• check: nơi setImmediate chạy, ngay sau poll.
• close: dọn dẹp, phát sự kiện đóng.

Loop KẾT THÚC khi không còn handle/request nào active
(không còn timer, socket hay callback đang chờ) — lúc đó
tiến trình Node thoát.','[]',770,180),

('n_dd_loop_vs_queue','Phân biệt Event Loop và Queue (có sơ đồ)','Backend',
'Nhầm lẫn phổ biến: nghĩ rằng chỉ có "một cái callback
queue". Thực tế event loop KHÔNG phải một hàng đợi, mà là
bộ ĐIỀU PHỐI; và có NHIỀU hàng đợi.

SƠ ĐỒ:

  EVENT LOOP = bộ điều phối (scheduler)
  │  nó lần lượt ghé từng phase; mỗi phase có 1 queue riêng:
  │
  ├─ timers queue      [ cb, cb, ... ]   (macrotask)
  ├─ pending queue     [ ... ]           (macrotask)
  ├─ poll / IO queue   [ ... ]           (macrotask)
  ├─ check queue       [ setImmediate ]  (macrotask)
  └─ close queue       [ ... ]           (macrotask)

  NGOÀI các phase, có 2 queue MICROTASK ưu tiên cao:
  ├─ nextTick queue    → xả TRƯỚC  (ưu tiên 1)
  └─ Promise queue     → xả SAU    (ưu tiên 2)

CÁCH GHÉP LẠI:
  chọn 1 phase → chạy hết queue của phase đó
    → xả hết nextTick queue
    → xả hết Promise queue
    → sang phase kế tiếp

Tóm lại:
• Event loop = người điều phối, quyết định "chạy cái gì,
  khi nào".
• Queue = nơi callback xếp hàng chờ.
Cái mà nhiều sơ đồ đơn giản gọi chung là "callback queue"
thực chất là NHIỀU queue tách theo từng phase, cộng thêm 2
queue microtask riêng.','[]',890,180),

('n_dd_poll','Poll phase — trái tim của event loop (cây quyết định)','Backend',
'Poll là phase quan trọng nhất, làm hai việc: (1) chạy
callback cho các sự kiện I/O đã hoàn tất; (2) quyết định
event loop có NGỦ (block) hay không, và bao lâu.

CÂY QUYẾT ĐỊNH khi vào POLL:

  Vào POLL phase
  │
  ├─ poll queue CÓ callback?
  │     └─ CÓ → chạy hết callback (tới giới hạn hệ thống)
  │             rồi đi tiếp sang check phase
  │
  └─ poll queue RỖNG?
        ├─ có setImmediate đang chờ?
        │     └─ KHÔNG ngủ → nhảy sang CHECK phase ngay
        │
        ├─ có timer sắp đến hạn?
        │     └─ ngủ TỐI ĐA tới thời điểm timer gần nhất,
        │        rồi quay lại TIMERS phase
        │
        └─ không có gì cả?
              └─ ngủ chờ I/O (epoll_wait) tới khi
                 kernel báo có sự kiện

Ý NGHĨA:
• Đây là lý do Node "ngủ" khi rảnh thay vì quay vòng đốt
  CPU (busy-wait) — hiệu quả năng lượng và CPU.
• Cũng giải thích vì sao thứ tự setTimeout(0) so với
  setImmediate là KHÔNG xác định khi gọi ở top-level (tùy
  loop có kịp bước qua ngưỡng ~1ms của timer hay chưa).','[]',650,240),

('n_dd_threadpool','Thread pool của libuv — cái gì chạy trên đó?','Backend',
'Thread pool của libuv mặc định có 4 luồng (chỉnh bằng
UV_THREADPOOL_SIZE, đặt TRƯỚC khi Node khởi động, tối đa
1024). Nó phục vụ các tác vụ blocking không có async ở
kernel.

SƠ ĐỒ:

  EVENT LOOP ──giao việc──► THREAD POOL (mặc định 4 luồng)
                             ├─ luồng #1  [bận: đọc file A]
                             ├─ luồng #2  [bận: pbkdf2]
                             ├─ luồng #3  [rảnh]
                             └─ luồng #4  [rảnh]
                                   │
                     xong việc ────┘
                             │
  EVENT LOOP ◄──đẩy kết quả về──┘  (callback vào phase phù hợp)

CÁI GÌ DÙNG THREAD POOL:
• fs.*  — đọc/ghi file (file I/O không non-blocking thật
  trên đa số OS).
• dns.lookup (getaddrinfo). Lưu ý: dns.resolve dùng mạng
  nên KHÔNG qua pool.
• crypto nặng: pbkdf2, scrypt, randomBytes (bản async),
  một phần TLS.
• zlib — nén/giải nén.

BẪY THỰC TẾ (hay bị bỏ sót):
Pool chỉ có 4 luồng. Nếu có 5 tác vụ nặng (ví dụ 5 lời gọi
pbkdf2) chạy đồng thời, tác vụ thứ 5 phải CHỜ một luồng
rảnh → xuất hiện độ trễ khó hiểu dù CPU còn rảnh. Cách xử
lý: tăng UV_THREADPOOL_SIZE hợp lý (thường bám theo số CPU
core), hoặc đẩy tính toán nặng sang Worker Threads.','[]',770,240),

('n_dd_nonblocking_os','Non-blocking I/O ở tầng OS: epoll / kqueue / IOCP','Backend',
'Node đạt hiệu năng I/O cao nhờ tận dụng cơ chế I/O bất
đồng bộ của kernel. Có HAI mô hình:

MÔ HÌNH 1 — READINESS (Linux epoll, macOS/BSD kqueue):
  App: "báo tôi khi socket này ĐỌC được"
    │  → đăng ký fd vào epoll
    ▼
  Kernel: (khi có data) "fd đã SẴN SÀNG"
    │
    ▼
  App: tự gọi read() non-blocking để lấy data

MÔ HÌNH 2 — COMPLETION (Windows IOCP):
  App: "đọc socket này giùm tôi"  → gửi yêu cầu
    │
    ▼
  Kernel: tự đọc xong  → "ĐÃ HOÀN TẤT, đây là data"

libuv trừu tượng cả hai sau một API chung.

VÌ SAO QUAN TRỌNG — so sánh mô hình phục vụ:

  Kiểu cũ (Apache/PHP truyền thống):
    1 kết nối = 1 thread (hoặc process)
    10.000 kết nối → 10.000 thread
    → tốn RAM, context-switch nặng, khó scale

  Kiểu Node (epoll):
    1 luồng dùng epoll theo dõi TẤT CẢ fd
    10.000 kết nối → 1 luồng + 1 danh sách fd
    → rất nhẹ (đây chính là bài toán C10K)

Với mạng, libuv dùng đúng epoll/kqueue/IOCP (1 luồng). Với
file, do giới hạn OS, libuv GIẢ LẬP async bằng thread pool.','[]',890,240),

('n_dd_singlethread','Vì sao "single-threaded" mà vẫn xử lý đồng thời?','Backend',
'Node là single-threaded ở chỗ: code JS CỦA BẠN chạy trên
MỘT luồng (main thread) — không bao giờ có hai đoạn JS chạy
song song, nên biến thường không cần lock/mutex. Nhưng nó
vẫn ĐỒNG THỜI nhờ offload I/O cho kernel/thread pool.

PHÂN BIỆT 2 KHÁI NIỆM (kèm sơ đồ):

  CONCURRENCY — xử lý xen kẽ trên 1 luồng (Node rất giỏi):
    req A ──gọi DB──▶ (đang chờ DB...)
    req B ─────────▶ được xử lý trong lúc A chờ
    req A ◀─DB xong─ chạy tiếp phần sau
    → 1 luồng, không ai ngồi chờ không

  PARALLELISM — chạy thật song song (cần Worker/cluster):
    core 1: ████ task 1
    core 2: ████ task 2   ← cùng thời điểm

HỆ QUẢ:
• Node cực mạnh với tải I/O-BOUND (API gọi DB/mạng/file):
  trong lúc chờ I/O, luồng JS đi làm việc khác.
• Với tải CPU-BOUND (tính toán nặng, vòng lặp lớn, mã hóa
  đồng bộ): luồng JS bị CHẶN, mọi request khác phải chờ →
  cần đẩy sang Worker Threads hoặc cluster để có
  parallelism thật.','[]',770,300),

-- ===== Section 11: Vòng đời request & Thứ tự thực thi =====
('n_dd_request_lifecycle','Luồng chạy của một HTTP request vào Node.js (từ A đến Z)','Backend',
'Trace đầy đủ một request GET đi vào server http/Express,
từ gói tin TCP tới lúc client nhận response.

SƠ ĐỒ THỜI GIAN:

  CLIENT
    │ (1) gửi HTTP request (gói TCP)
    ▼
  KERNEL ── đánh dấu socket readable ──► epoll báo cho libuv
    │
    ▼
  (2) POLL phase: libuv đọc bytes,
      llhttp parse HTTP
      → tạo req (IncomingMessage = Readable stream)
      → tạo res (ServerResponse = Writable stream)
    │
    ▼
  (3) V8 chạy handler JS của bạn (đồng bộ, 1 luồng)
    │  ví dụ: app.get("/x", async (req,res) => { ... })
    ▼
  (4) handler gọi I/O:  await db.query(...)
    │  → lệnh gửi qua socket DB, handler RETURN NGAY
    │  → luồng chính RẢNH, phục vụ request khác
    ⋮   ... event loop tiếp tục quay các vòng khác ...
    ▼
  (5) DB trả kết quả → socket DB readable
    │  → POLL phase chạy callback
    │  → Promise resolve → code sau await vào
    │    microtask queue → chạy nốt
    ▼
  (6) res.json(...) / res.end()
    │  → ghi data ra socket (non-blocking)
    │  → nếu buffer đầy: chờ sự kiện "drain" (backpressure)
    ▼
  KERNEL gửi gói TCP về CLIENT
    │
    ▼
  (7) keep-alive (giữ socket tái dùng)
      hoặc close (chạy ở close-callbacks phase)

ĐIỂM CỐT LÕI: bước (4)-(5) là lý do MỘT luồng phục vụ được
hàng nghìn request đan xen — trong lúc request này chờ I/O,
luồng đi xử lý request khác thay vì đứng chờ.','[]',1050,180),

('n_dd_exec_order','Thứ tự thực thi: nextTick vs Promise vs timer vs I/O','Backend',
'Quy tắc vàng: sau MỖI callback và giữa mỗi phase, Node xả
HẾT nextTick queue → rồi HẾT Promise microtask queue → mới
chạy macrotask kế tiếp.

VÍ DỤ KINH ĐIỂN:
  console.log("1");
  setTimeout(() => console.log("2 timeout"), 0);
  setImmediate(() => console.log("3 immediate"));
  Promise.resolve().then(() => console.log("4 promise"));
  process.nextTick(() => console.log("5 nextTick"));
  console.log("6");

TRACE TỪNG BƯỚC:

  ◆ Pha đồng bộ (chạy tuần tự ngay):
      in "1"
      đăng ký timeout   → timers queue:  [2]
      đăng ký immediate → check queue:   [3]
      đăng ký .then     → Promise queue: [4]
      đăng ký nextTick  → nextTick queue:[5]
      in "6"

  ◆ Hết đồng bộ → xả microtask:
      nextTick queue trước → in "5"
      Promise queue sau    → in "4"

  ◆ Vào event loop (các phase):
      timers phase → in "2"
      check  phase → in "3"

  ➜ KẾT QUẢ:  1  6  5  4  2  3

GHI CHÚ:
• Mã đồng bộ luôn xong trước (1, 6).
• nextTick (5) luôn trước Promise (4); cả hai luôn trước
  timer/immediate.
• Ở top-level, thứ tự 2 (timeout) vs 3 (immediate) KHÔNG
  đảm bảo; nhưng nếu đặt trong một callback I/O thì 3
  (immediate) luôn trước.','[]',1170,180),

('n_dd_timeout_immediate','setTimeout(0) vs setImmediate: ai chạy trước?','Backend',
'Kết quả phụ thuộc bạn gọi chúng Ở ĐÂU trong chu kỳ event
loop.

VỊ TRÍ TRONG MỘT VÒNG LOOP:

  ... → poll ──▶ check ──▶ (vòng mới) timers → ...
                  ▲                      ▲
           setImmediate            setTimeout(0)

  → Đứng ở poll (nơi callback I/O chạy), phase NGAY SAU là
    check. Vì vậy TRONG một callback I/O: setImmediate luôn
    chạy TRƯỚC setTimeout(0), còn timers phải chờ tới vòng
    lặp kế tiếp.

TRƯỜNG HỢP 1 — trong callback I/O (kết quả XÁC ĐỊNH):
  const fs = require("fs");
  fs.readFile(__filename, () => {
    setTimeout(() => console.log("timeout"), 0);
    setImmediate(() => console.log("immediate"));
  });
  // LUÔN in:  immediate  →  timeout

TRƯỜNG HỢP 2 — ở top-level (kết quả KHÔNG xác định):
  setTimeout(() => console.log("timeout"), 0);
  setImmediate(() => console.log("immediate"));
  // Thứ tự có thể đổi mỗi lần chạy, vì setTimeout(0) thực
  // chất có ngưỡng tối thiểu ~1ms; tùy loop có kịp qua
  // ngưỡng đó chưa.

KẾT LUẬN THỰC DỤNG:
Muốn "chạy ngay sau khi I/O hiện tại xong" thì dùng
setImmediate — nó có vị trí xác định trong chu kỳ;
setTimeout(0) thì không.','[]',1290,180),

('n_dd_async_await_compile','async/await dưới góc nhìn engine (V8 & microtask)','Backend',
'async/await chỉ là cú pháp trên nền Promise. Hiểu được nó
"biên dịch" thành gì sẽ giải thích chính xác thứ tự chạy.

KHI GẶP await:
• Hàm async TẠM DỪNG tại điểm await và trả về một Promise
  cho caller NGAY (không chặn luồng).
• Toàn bộ code SAU await được đăng ký như một MICROTASK,
  chỉ chạy khi Promise được await đã resolve.

MINH HỌA — hai đoạn sau tương đương:

  // Viết bằng async/await:
  async function f() {
    console.log("A");
    await something;        // ◄ ĐIỂM CẮT
    console.log("B");       // ◄ phần này thành microtask
  }

  // Tương đương (đơn giản hoá):
  function f() {
    console.log("A");
    return Promise.resolve(something).then(() => {
      console.log("B");
    });
  }

  → "A" chạy ĐỒNG BỘ; "B" bị HOÃN vào microtask queue —
    kể cả khi something đã sẵn sàng (await 5 vẫn hoãn "B").

HỆ QUẢ:
• await luôn nhường cho event loop ít nhất một lượt
  microtask.
• Một chuỗi async/await thực chất là các microtask nối
  tiếp nhau → chúng LUÔN chạy trước setTimeout/setImmediate
  của cùng lượt.
• V8 hiện đại đã tối ưu để await một Promise gốc không tạo
  Promise trung gian dư thừa.','[]',1050,240),

('n_dd_promise_microtask','Promise resolve đi vào microtask queue ra sao?','Backend',
'Khi một Promise chuyển trạng thái, các callback
.then/.catch/.finally KHÔNG chạy ngay mà được đẩy vào
MICROTASK QUEUE (PromiseJobs của V8).

SƠ ĐỒ VÒNG ĐỜI:

  Promise (pending)
    │  resolve(value)
    ▼
  Promise (fulfilled)
    │  đẩy các .then callback vào MICROTASK QUEUE
    │  (KHÔNG chạy ngay tại chỗ)
    ▼
  Event loop: sau mỗi macrotask/phase → xả microtask queue
    │  nếu callback lại tạo microtask mới
    │  → xả luôn trong CÙNG lượt
    ▼
  ... lặp cho tới khi queue RỖNG mới đi tiếp phase khác

HAI QUEUE MICROTASK CỦA NODE (thứ tự xả):
  ├─ nextTick queue   → xả TRƯỚC (đặc thù Node, không có
  │                      trong chuẩn JS)
  └─ Promise queue    → xả SAU

CÔNG CỤ & LƯU Ý:
• queueMicrotask(fn) cho phép tự đẩy hàm vào đúng Promise
  microtask queue.
• Vì microtask được xả tới RỖNG, một chuỗi microtask quá
  dài (hoặc tự sinh vô hạn) có thể trì hoãn I/O và timer —
  xem node "starvation".','[]',1170,240),

('n_dd_starvation','Đói I/O do nextTick / microtask (starvation)','Backend',
'Vì Node xả TOÀN BỘ nextTick queue (rồi tới Promise queue)
trước khi cho event loop đi tiếp, một callback liên tục tự
lên lịch lại bằng nextTick (hoặc đệ quy microtask) sẽ khiến
loop KHÔNG BAO GIỜ tới poll phase → I/O và timer bị bỏ đói,
app như bị "treo" dù CPU không nặng.

SƠ ĐỒ SO SÁNH:

  ✗ SAI — kẹt event loop (starvation):
      function loop() { process.nextTick(loop); }
      loop();

      nextTick queue KHÔNG BAO GIỜ rỗng
        → xả microtask mãi không hết
        → loop không tới được poll phase
        → mọi I/O / timer bị bỏ đói → app treo

  ✓ ĐÚNG — nhường I/O:
      function loop() { setImmediate(loop); }
      loop();

      setImmediate chạy ở check phase
        → giữa mỗi lần lặp, loop VẪN ghé qua poll
        → I/O và timer vẫn được phục vụ

KẾT LUẬN:
Đây là khác biệt THỰC TẾ quan trọng nhất giữa
process.nextTick và setImmediate:
• nextTick = "chen ngay lập tức", dễ gây đói I/O nếu lạm
  dụng/đệ quy.
• setImmediate = "chờ tới lượt sau poll", an toàn cho vòng
  lặp cần nhường I/O.','[]',1290,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), links=VALUES(links);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_t_ndc_s_ndc_10_part-of','t_ndc','s_ndc_10','part-of'),
('e_t_ndc_s_ndc_11_part-of','t_ndc','s_ndc_11','part-of'),
('e_s_ndc_10_n_dd_libuv_part-of','s_ndc_10','n_dd_libuv','part-of'),
('e_s_ndc_10_n_dd_eventloop_detail_part-of','s_ndc_10','n_dd_eventloop_detail','part-of'),
('e_s_ndc_10_n_dd_loop_vs_queue_part-of','s_ndc_10','n_dd_loop_vs_queue','part-of'),
('e_s_ndc_10_n_dd_poll_part-of','s_ndc_10','n_dd_poll','part-of'),
('e_s_ndc_10_n_dd_threadpool_part-of','s_ndc_10','n_dd_threadpool','part-of'),
('e_s_ndc_10_n_dd_nonblocking_os_part-of','s_ndc_10','n_dd_nonblocking_os','part-of'),
('e_s_ndc_10_n_dd_singlethread_part-of','s_ndc_10','n_dd_singlethread','part-of'),
('e_s_ndc_11_n_dd_request_lifecycle_part-of','s_ndc_11','n_dd_request_lifecycle','part-of'),
('e_s_ndc_11_n_dd_exec_order_part-of','s_ndc_11','n_dd_exec_order','part-of'),
('e_s_ndc_11_n_dd_timeout_immediate_part-of','s_ndc_11','n_dd_timeout_immediate','part-of'),
('e_s_ndc_11_n_dd_async_await_compile_part-of','s_ndc_11','n_dd_async_await_compile','part-of'),
('e_s_ndc_11_n_dd_promise_microtask_part-of','s_ndc_11','n_dd_promise_microtask','part-of'),
('e_s_ndc_11_n_dd_starvation_part-of','s_ndc_11','n_dd_starvation','part-of'),
('e_n_dd_libuv_n_el_arch_related','n_dd_libuv','n_el_arch','related'),
('e_n_dd_eventloop_detail_n_el_phases_related','n_dd_eventloop_detail','n_el_phases','related'),
('e_n_dd_eventloop_detail_q_1_related','n_dd_eventloop_detail','q_1','related'),
('e_n_dd_loop_vs_queue_n_el_micro_macro_related','n_dd_loop_vs_queue','n_el_micro_macro','related'),
('e_n_dd_threadpool_n_fs_related','n_dd_threadpool','n_fs','related'),
('e_n_dd_poll_n_el_phases_related','n_dd_poll','n_el_phases','related'),
('e_n_dd_singlethread_n_worker_vs_cluster_related','n_dd_singlethread','n_worker_vs_cluster','related'),
('e_n_dd_exec_order_n_el_nexttick_related','n_dd_exec_order','n_el_nexttick','related'),
('e_n_dd_timeout_immediate_n_el_timers_related','n_dd_timeout_immediate','n_el_timers','related'),
('e_n_dd_starvation_n_el_nexttick_related','n_dd_starvation','n_el_nexttick','related'),
('e_n_dd_request_lifecycle_n_http_related','n_dd_request_lifecycle','n_http','related'),
('e_n_dd_async_await_compile_q_3_related','n_dd_async_await_compile','q_3','related'),
('e_n_dd_promise_microtask_n_el_micro_macro_related','n_dd_promise_microtask','n_el_micro_macro','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
