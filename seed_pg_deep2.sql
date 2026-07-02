-- ĐÀO SÂU PostgreSQL (đợt 1b): EXPLAIN, Kiến trúc, Transaction
UPDATE kg_nodes SET
description=
'EXPLAIN cho biết KẾ HOẠCH; thêm ANALYZE để CHẠY THẬT và xem số liệu
thực tế.

VÍ DỤ + đọc output:

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42 ORDER BY created_at DESC;

  -- Output mẫu (đọc từ TRONG ra NGOÀI, node thụt sâu chạy trước):
  Sort  (cost=8.31..8.32 rows=5 width=40)
        (actual time=0.045..0.046 rows=5 loops=1)
    Sort Key: created_at DESC
    ->  Index Scan using idx_orders_user on orders
          (cost=0.28..8.29 rows=5 width=40)
          (actual time=0.020..0.030 rows=5 loops=1)
        Index Cond: (user_id = 42)
  Planning Time: 0.10 ms
  Execution Time: 0.07 ms

Ý NGHĨA TỪNG PHẦN:
  • Index Scan using idx_orders_user : CÓ dùng index (tốt).
  • cost=0.28..8.29 : chi phí ƯỚC LƯỢNG (khởi động .. tổng).
  • actual time=... : thời gian THỰC TẾ (ms) do ANALYZE đo.
  • rows=5 (ước lượng) so rows=5 (actual) khớp -> thống kê tốt.
  • loops=1 : node chạy 1 lần (trong Nested Loop có thể nhiều lần).

DẤU HIỆU XẤU CẦN SOI:
  • Seq Scan trên bảng lớn kèm điều kiện lọc  -> thiếu index.
  • rows ước lượng lệch XA rows thật          -> thống kê cũ, chạy ANALYZE.
  • Sort/Hash kèm "external merge Disk"        -> tăng work_mem.

Quy trình: đọc node trong cùng trước, tìm nơi tốn actual time nhất
rồi tối ưu đúng chỗ đó.'
,description_en=
'EXPLAIN shows the PLAN; add ANALYZE to actually RUN it and see real
numbers.

EXAMPLE + reading the output:

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42 ORDER BY created_at DESC;

  -- Sample output (read INSIDE-OUT, the deeper-indented node runs first):
  Sort  (cost=8.31..8.32 rows=5 width=40)
        (actual time=0.045..0.046 rows=5 loops=1)
    Sort Key: created_at DESC
    ->  Index Scan using idx_orders_user on orders
          (cost=0.28..8.29 rows=5 width=40)
          (actual time=0.020..0.030 rows=5 loops=1)
        Index Cond: (user_id = 42)
  Planning Time: 0.10 ms
  Execution Time: 0.07 ms

MEANING OF EACH PART:
  • Index Scan using idx_orders_user : an index IS used (good).
  • cost=0.28..8.29 : ESTIMATED cost (startup .. total).
  • actual time=... : REAL time (ms) measured by ANALYZE.
  • rows=5 (estimate) vs rows=5 (actual) match -> good statistics.
  • loops=1 : the node ran once (inside a Nested Loop it may run many).

BAD SIGNS TO WATCH:
  • Seq Scan on a big filtered table   -> missing index.
  • estimated rows far from actual rows -> stale stats, run ANALYZE.
  • Sort/Hash with "external merge Disk" -> raise work_mem.

Process: read the innermost node first, find where actual time is
spent, then optimize exactly there.'
WHERE id='n_pg_explain';

UPDATE kg_nodes SET
description=
'PostgreSQL theo mô hình ĐA TIẾN TRÌNH (mỗi kết nối = 1 process backend).

SƠ ĐỒ:
  Client ─┬─► postmaster (cha, cổng 5432) ─fork─► backend (1 / kết nối)
          │                                          │
          │                            ┌ Shared memory ┐
          │                            │ shared_buffers │  (cache trang)
          │                            │ WAL buffers    │
          │                            └────────────────┘
          │                                          │
          └────────────────► data files + WAL trên đĩa
              + background workers: autovacuum, checkpointer, WAL writer

VÒNG ĐỜI MỘT QUERY (từng bước):
  1. Client mở kết nối -> postmaster FORK một backend process riêng.
  2. Backend nhận SQL -> Parser (cú pháp) -> Rewriter (view/rule)
     -> Planner (chọn kế hoạch rẻ nhất) -> Executor (chạy).
  3. Executor đọc trang từ shared_buffers; nếu thiếu -> đọc từ đĩa
     vào buffer (cache lại cho lần sau).
  4. Khi ghi: sửa trang trong buffer + ghi WAL trước (xem node WAL).
  5. Trả kết quả về client.

CẤU HÌNH QUAN TRỌNG (postgresql.conf):
  shared_buffers  = 25% RAM     -- cache trang dữ liệu
  work_mem        = 16MB        -- bộ nhớ sort/hash cho MỖI node query
  max_connections = 100         -- mỗi kết nối là 1 process (khá nặng)

Vì mỗi kết nối là một process tốn tài nguyên -> dùng PgBouncer
(connection pooler) khi có nhiều client, thay vì mở hàng nghìn kết
nối trực tiếp tới PostgreSQL.'
,description_en=
'PostgreSQL uses a MULTI-PROCESS model (each connection = 1 backend
process).

DIAGRAM:
  Client ─┬─► postmaster (parent, port 5432) ─fork─► backend (1 / conn)
          │                                          │
          │                            ┌ Shared memory ┐
          │                            │ shared_buffers │  (page cache)
          │                            │ WAL buffers    │
          │                            └────────────────┘
          │                                          │
          └────────────────► data files + WAL on disk
              + background workers: autovacuum, checkpointer, WAL writer

LIFECYCLE OF ONE QUERY (step by step):
  1. Client connects -> postmaster FORKS a dedicated backend process.
  2. Backend gets SQL -> Parser (syntax) -> Rewriter (views/rules)
     -> Planner (pick the cheapest plan) -> Executor (run it).
  3. Executor reads pages from shared_buffers; on a miss -> read from
     disk into the buffer (cached for next time).
  4. On write: modify the page in the buffer + write WAL first (see WAL).
  5. Return the result to the client.

IMPORTANT CONFIG (postgresql.conf):
  shared_buffers  = 25% RAM     -- data page cache
  work_mem        = 16MB        -- sort/hash memory per query NODE
  max_connections = 100         -- each connection is a process (heavy)

Because each connection is a resource-heavy process -> use PgBouncer
(a connection pooler) with many clients, instead of opening thousands
of direct connections to PostgreSQL.'
WHERE id='n_pg_arch';

UPDATE kg_nodes SET
description=
'Transaction gom nhiều lệnh thành một đơn vị ACID: hoặc thành công
TẤT CẢ (COMMIT), hoặc hủy TẤT CẢ (ROLLBACK).

VÍ DỤ chuyển tiền (phải nguyên tử):
  BEGIN;
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
    UPDATE acc SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- lỗi giữa chừng (chưa COMMIT) -> ROLLBACK, không mất tiền

SAVEPOINT (rollback MỘT PHẦN, không hủy cả giao dịch):
  BEGIN;
    INSERT INTO orders (...) VALUES (...);
    SAVEPOINT sp1;
    INSERT INTO items (...) VALUES (...);   -- giả sử vi phạm ràng buộc
    ROLLBACK TO sp1;                        -- hủy TỪ sp1, GIỮ order
    INSERT INTO items (...) VALUES (...);   -- thử lại bản đúng
  COMMIT;

XỬ LÝ TRONG CODE (thư viện pg của Node — tự ROLLBACK khi lỗi):
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("UPDATE acc SET bal=bal-100 WHERE id=1");
    await client.query("UPDATE acc SET bal=bal+100 WHERE id=2");
    await client.query("COMMIT");
  } catch (e) {
    await client.query("ROLLBACK");   // QUAN TRỌNG: nhả giao dịch lỗi
    throw e;
  } finally {
    client.release();                 // luôn trả kết nối về pool
  }

LƯU Ý: transaction mở LÂU giữ snapshot cũ -> cản VACUUM dọn tuple
chết -> hãy giữ giao dịch NGẮN gọn.'
,description_en=
'A transaction groups statements into one ACID unit: either ALL
succeed (COMMIT) or ALL are undone (ROLLBACK).

MONEY-TRANSFER EXAMPLE (must be atomic):
  BEGIN;
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
    UPDATE acc SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- a mid-way error (not COMMITted) -> ROLLBACK, no lost money

SAVEPOINT (PARTIAL rollback without aborting the whole transaction):
  BEGIN;
    INSERT INTO orders (...) VALUES (...);
    SAVEPOINT sp1;
    INSERT INTO items (...) VALUES (...);   -- suppose it violates a constraint
    ROLLBACK TO sp1;                        -- undo FROM sp1, KEEP the order
    INSERT INTO items (...) VALUES (...);   -- retry with a correct row
  COMMIT;

HANDLING IN CODE (Node pg library - ROLLBACK on error):
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("UPDATE acc SET bal=bal-100 WHERE id=1");
    await client.query("UPDATE acc SET bal=bal+100 WHERE id=2");
    await client.query("COMMIT");
  } catch (e) {
    await client.query("ROLLBACK");   // IMPORTANT: release the failed txn
    throw e;
  } finally {
    client.release();                 // always return the connection to the pool
  }

NOTE: a long-open transaction holds an old snapshot -> it blocks
VACUUM from cleaning dead tuples -> keep transactions SHORT.'
WHERE id='n_pg_txn';
