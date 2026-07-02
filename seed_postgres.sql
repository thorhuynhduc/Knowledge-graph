-- ===================================================================
--  TOPIC: PostgreSQL Core (song ngữ VI + EN, ví dụ + sơ đồ)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_postgres.sql
--  Idempotent (ON DUPLICATE KEY UPDATE).
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
-- Topic
('t_pg','PostgreSQL Core','Database',
'Kiến thức chuyên sâu về PostgreSQL: kiến trúc tiến trình, MVCC, WAL, index và query planner, transaction/isolation, cùng các tính năng nâng cao (JSONB, CTE, window, partition). Dùng để hiểu bản chất khi tối ưu và phỏng vấn.',
'In-depth PostgreSQL: process architecture, MVCC, WAL, indexes and the query planner, transactions/isolation, plus advanced features (JSONB, CTE, window, partitioning). For deep understanding when tuning and in interviews.',
'[]',150,300),

-- Sections
('s_pg_1','Kiến trúc & MVCC','Database',
'Cách PostgreSQL tổ chức tiến trình/bộ nhớ và mô hình đa phiên bản (MVCC), WAL, VACUUM.',
'How PostgreSQL organizes processes/memory and its multi-version model (MVCC), WAL, and VACUUM.',
'[]',60,180),
('s_pg_2','Index & Query Planner','Database',
'Các loại index, cách planner chọn kế hoạch, và cách đọc EXPLAIN.',
'Index types, how the planner chooses a plan, and how to read EXPLAIN.',
'[]',260,180),
('s_pg_3','Transaction & Isolation','Database',
'Các mức cô lập, khóa (lock), deadlock và cách giao dịch hoạt động.',
'Isolation levels, locking, deadlocks, and how transactions work.',
'[]',60,440),
('s_pg_4','Tính năng nâng cao','Database',
'JSONB, CTE & window function, kiểu dữ liệu phong phú và partitioning.',
'JSONB, CTE & window functions, rich data types, and partitioning.',
'[]',260,440),

-- ===== Section 1: Kiến trúc & MVCC =====
('n_pg_arch','Kiến trúc tiến trình & bộ nhớ','Database',
'PostgreSQL theo mô hình ĐA TIẾN TRÌNH (mỗi kết nối = 1 process), khác
MySQL (đa luồng).

SƠ ĐỒ:

  Client ──┐
  Client ──┼─► postmaster (tiến trình cha, lắng nghe cổng 5432)
  Client ──┘        │  fork mỗi kết nối
                    ▼
              backend process (1 cho mỗi client)
                    │  đọc/ghi qua
                    ▼
  ┌─ Shared memory ───────────────────────────┐
  │  shared_buffers  (cache trang dữ liệu)     │
  │  WAL buffers                               │
  └────────────────────────────────────────────┘
                    │
                    ▼
     Data files trên đĩa + WAL + background workers
     (autovacuum, checkpointer, WAL writer)

Vì mỗi kết nối là 1 process khá nặng -> nên dùng connection
pooler (PgBouncer) thay vì mở hàng nghìn kết nối trực tiếp.',
'PostgreSQL uses a MULTI-PROCESS model (each connection = 1 process),
unlike MySQL (multi-threaded).

DIAGRAM:

  Client ──┐
  Client ──┼─► postmaster (parent process, listens on port 5432)
  Client ──┘        │  forks per connection
                    ▼
              backend process (one per client)
                    │  reads/writes via
                    ▼
  ┌─ Shared memory ───────────────────────────┐
  │  shared_buffers  (data page cache)         │
  │  WAL buffers                               │
  └────────────────────────────────────────────┘
                    │
                    ▼
     Data files on disk + WAL + background workers
     (autovacuum, checkpointer, WAL writer)

Because each connection is a fairly heavy process, use a
connection pooler (PgBouncer) instead of opening thousands of
direct connections.',
'[]',20,120),

('n_pg_mvcc','MVCC — đa phiên bản','Database',
'MVCC (Multi-Version Concurrency Control): mỗi UPDATE/DELETE KHÔNG
ghi đè tại chỗ mà tạo phiên bản mới của hàng (tuple). Người đọc
không chặn người ghi và ngược lại.

Mỗi tuple có 2 cột hệ thống ẩn:
  xmin = id transaction đã TẠO tuple
  xmax = id transaction đã XÓA/thay thế tuple

Ví dụ UPDATE:
  hàng cũ: (xmin=100, xmax=205)   <- bị đánh dấu chết
  hàng mới:(xmin=205, xmax=0)     <- phiên bản hiện hành

Mỗi transaction thấy snapshot theo id của mình -> đọc nhất
quán mà không cần khóa đọc.

HỆ QUẢ: tuple chết (dead tuple) tích tụ -> cần VACUUM dọn dẹp,
nếu không sẽ phình bảng (table bloat).',
'MVCC (Multi-Version Concurrency Control): an UPDATE/DELETE does
NOT overwrite in place; it creates a new version of the row
(tuple). Readers do not block writers and vice versa.

Every tuple has 2 hidden system columns:
  xmin = id of the transaction that CREATED the tuple
  xmax = id of the transaction that DELETED/replaced it

Example UPDATE:
  old row: (xmin=100, xmax=205)   <- marked dead
  new row: (xmin=205, xmax=0)     <- current version

Each transaction sees a snapshot based on its own id -> a
consistent read without read locks.

CONSEQUENCE: dead tuples accumulate -> VACUUM is needed to
clean them, otherwise the table bloats.',
'[]',140,120),

('n_pg_wal','WAL & Durability','Database',
'WAL (Write-Ahead Log): mọi thay đổi được ghi vào log TUẦN TỰ
TRƯỚC khi ghi vào data file. Đây là nền của độ bền (durability)
và khả năng phục hồi sau sự cố.

Luồng ghi:
  1. Sửa trang trong shared_buffers (trong RAM)
  2. Ghi bản ghi WAL + fsync khi COMMIT  <- điểm bền vững
  3. Trang "bẩn" được flush xuống đĩa sau (checkpoint)

Nhờ đó: nếu mất điện, khởi động lại sẽ replay WAL để khôi phục.
WAL cũng là nguồn cho replication (streaming) và PITR
(point-in-time recovery).

fsync=off nhanh hơn nhưng MẤT AN TOÀN — đừng dùng ở production.',
'WAL (Write-Ahead Log): every change is written SEQUENTIALLY to
the log BEFORE being written to the data files. This is the
basis of durability and crash recovery.

Write flow:
  1. Modify the page in shared_buffers (in RAM)
  2. Write the WAL record + fsync on COMMIT  <- durability point
  3. Dirty pages are flushed to disk later (checkpoint)

So if power is lost, on restart PostgreSQL replays the WAL to
recover. WAL also feeds replication (streaming) and PITR
(point-in-time recovery).

fsync=off is faster but UNSAFE - do not use it in production.',
'[]',20,180),

('n_pg_vacuum','VACUUM & Bloat','Database',
'Vì MVCC để lại tuple chết, VACUUM dọn chúng để tái sử dụng không
gian. autovacuum chạy tự động nền.

  VACUUM         : đánh dấu không gian tuple chết là tái dùng được
                   (không trả lại OS), cập nhật thống kê.
  VACUUM FULL    : nén bảng, TRẢ không gian cho OS, nhưng KHÓA bảng
                   (tránh chạy giờ cao điểm).
  ANALYZE        : cập nhật thống kê cho planner.

Dấu hiệu cần chú ý: bảng phình to, query chậm dần, transaction id
wraparound (nguy hiểm) -> theo dõi autovacuum.

Ví dụ:
  VACUUM (ANALYZE, VERBOSE) my_table;',
'Because MVCC leaves dead tuples behind, VACUUM cleans them so the
space can be reused. autovacuum runs automatically in the
background.

  VACUUM       : marks dead tuple space as reusable (does not
                 return it to the OS), updates statistics.
  VACUUM FULL  : compacts the table, RETURNS space to the OS, but
                 LOCKS the table (avoid during peak hours).
  ANALYZE      : refreshes statistics for the planner.

Warning signs: growing tables, gradually slower queries,
transaction id wraparound (dangerous) -> monitor autovacuum.

Example:
  VACUUM (ANALYZE, VERBOSE) my_table;',
'[]',140,180),

-- ===== Section 2: Index & Planner =====
('n_pg_btree','B-tree index','Database',
'B-tree là index mặc định, hợp cho so sánh =, <, >, BETWEEN,
ORDER BY và LIKE "abc%" (tiền tố).

SƠ ĐỒ (cây cân bằng, lá liên kết):

        [ 50 | 100 ]            <- nút gốc
         /     |     \
   [..30] [50..80] [100..]      <- nút trong
      │       │        │
    lá ↔    lá ↔      lá ↔      <- lá trỏ tới hàng (liên kết đôi)

Tra cứu ~ O(log n). Lá nối nhau nên quét khoảng (range) nhanh.

Ví dụ + index nhiều cột (thứ tự cột quan trọng):
  CREATE INDEX idx_u_email ON users (email);
  CREATE INDEX idx_o_uid_date ON orders (user_id, created_at);
  -- index (a,b) phục vụ WHERE a=?  và  a=? AND b=?
  -- KHÔNG phục vụ tốt WHERE b=? đơn lẻ',
'B-tree is the default index, good for =, <, >, BETWEEN, ORDER BY,
and LIKE "abc%" (prefix).

DIAGRAM (balanced tree, linked leaves):

        [ 50 | 100 ]            <- root node
         /     |     \
   [..30] [50..80] [100..]      <- internal nodes
      │       │        │
    leaf ↔  leaf ↔   leaf ↔     <- leaves point to rows (doubly linked)

Lookup is ~ O(log n). Leaves are linked so range scans are fast.

Example + multi-column index (column order matters):
  CREATE INDEX idx_u_email ON users (email);
  CREATE INDEX idx_o_uid_date ON orders (user_id, created_at);
  -- index (a,b) serves WHERE a=?  and  a=? AND b=?
  -- does NOT serve WHERE b=? alone well',
'[]',220,120),

('n_pg_index_types','Các loại index khác (GIN/GiST/BRIN)','Database',
'Ngoài B-tree, PostgreSQL có nhiều loại index chuyên biệt:

  GIN   : cho giá trị chứa nhiều phần tử — JSONB, mảng,
          full-text search. Vd: tìm khóa trong JSONB.
  GiST  : dữ liệu hình học, không gian (PostGIS), phạm vi.
  BRIN  : bảng RẤT lớn, dữ liệu sắp theo thứ tự tự nhiên
          (vd log theo thời gian) — index nhỏ gọn.
  Hash  : chỉ cho so sánh = (ít dùng hơn B-tree).

Ví dụ GIN cho JSONB:
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

Ví dụ full-text:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));

Chọn đúng loại index theo dạng truy vấn là chìa khóa tối ưu.',
'Besides B-tree, PostgreSQL has several specialized index types:

  GIN   : for values containing many elements - JSONB, arrays,
          full-text search. E.g. find a key inside JSONB.
  GiST  : geometric/spatial data (PostGIS), ranges.
  BRIN  : VERY large tables whose data is naturally ordered
          (e.g. time-series logs) - a tiny index.
  Hash  : only for = comparisons (less used than B-tree).

GIN example for JSONB:
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

Full-text example:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));

Choosing the right index type for your query shape is the key to
tuning.',
'[]',300,120),

('n_pg_explain','Đọc EXPLAIN ANALYZE','Database',
'EXPLAIN cho biết KẾ HOẠCH planner chọn; thêm ANALYZE để chạy thật
và xem thời gian/row thực tế.

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42;

Đọc từ trong ra ngoài. Các node hay gặp:
  Seq Scan     : quét toàn bảng (xấu nếu bảng lớn + có điều kiện lọc)
  Index Scan   : dùng index rồi lấy hàng
  Bitmap Scan  : nhiều hàng rải rác -> gom qua bitmap
  Nested Loop / Hash Join / Merge Join : cách nối bảng

Điều cần soi:
  • cost=... (ước lượng) vs actual time=... (thực tế)
  • rows ước lượng vs rows thật lệch nhiều -> thống kê cũ, chạy ANALYZE
  • Seq Scan trên bảng lớn -> cân nhắc thêm index',
'EXPLAIN shows the PLAN the planner picked; add ANALYZE to actually
run it and see real time/rows.

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42;

Read from the inside out. Common nodes:
  Seq Scan     : full table scan (bad on a large filtered table)
  Index Scan   : use an index then fetch rows
  Bitmap Scan  : many scattered rows -> gather via a bitmap
  Nested Loop / Hash Join / Merge Join : join strategies

What to inspect:
  • cost=... (estimate) vs actual time=... (real)
  • estimated rows vs real rows differing a lot -> stale stats,
    run ANALYZE
  • Seq Scan on a big table -> consider adding an index',
'[]',220,180),

('n_pg_planner','Query Planner & Thống kê','Database',
'Planner là bộ tối ưu DỰA TRÊN CHI PHÍ (cost-based): nó ước lượng
chi phí nhiều kế hoạch rồi chọn cái rẻ nhất, dựa vào THỐNG KÊ về
phân bố dữ liệu (pg_statistic, cập nhật bởi ANALYZE).

Vì sao planner bỏ qua index của bạn?
  • Bảng nhỏ -> Seq Scan nhanh hơn dùng index.
  • Điều kiện khớp quá nhiều hàng (vd > ~5-10% bảng) -> quét tuần
    tự rẻ hơn.
  • Thống kê cũ -> ước lượng sai -> chọn nhầm. Chạy ANALYZE.
  • Hàm bọc quanh cột (WHERE lower(email)=...) làm index thường
    vô dụng -> cần expression index.

Mẹo: nâng default_statistics_target cho cột lệch phân bố; dùng
EXPLAIN ANALYZE để xác nhận thay vì đoán.',
'The planner is a COST-BASED optimizer: it estimates the cost of
several plans and picks the cheapest, using STATISTICS about data
distribution (pg_statistic, updated by ANALYZE).

Why does the planner ignore your index?
  • Small table -> a Seq Scan is faster than using an index.
  • The predicate matches too many rows (e.g. > ~5-10% of the
    table) -> a sequential scan is cheaper.
  • Stale statistics -> wrong estimate -> wrong choice. Run ANALYZE.
  • A function wrapped around a column (WHERE lower(email)=...)
    makes a normal index useless -> use an expression index.

Tip: raise default_statistics_target for skewed columns; use
EXPLAIN ANALYZE to confirm instead of guessing.',
'[]',300,180),

-- ===== Section 3: Transaction & Isolation =====
('n_pg_isolation','4 mức Isolation & Anomalies','Database',
'Mức cô lập điều chỉnh việc một transaction thấy gì từ transaction
khác. Chuẩn SQL có 4 mức; PostgreSQL mặc định READ COMMITTED.

  Mức               | Dirty read | Non-repeatable | Phantom
  ------------------|-----------|----------------|--------
  READ UNCOMMITTED  | (PG coi như READ COMMITTED)
  READ COMMITTED    | Không     | Có thể         | Có thể
  REPEATABLE READ   | Không     | Không          | Không (PG chặn)
  SERIALIZABLE      | Không     | Không          | Không

Giải nghĩa nhanh:
  • Dirty read: đọc dữ liệu chưa commit.
  • Non-repeatable: đọc lại cùng hàng ra giá trị khác.
  • Phantom: cùng điều kiện, lần sau ra thêm/bớt hàng.

Ví dụ:
  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT ... ; -- snapshot cố định suốt transaction
  COMMIT;

PG dùng snapshot MVCC nên REPEATABLE READ đã chặn cả phantom.',
'The isolation level controls what one transaction sees from
others. The SQL standard defines 4 levels; PostgreSQL defaults to
READ COMMITTED.

  Level             | Dirty read | Non-repeatable | Phantom
  ------------------|-----------|----------------|--------
  READ UNCOMMITTED  | (PG treats this as READ COMMITTED)
  READ COMMITTED    | No        | Possible       | Possible
  REPEATABLE READ   | No        | No             | No (PG prevents)
  SERIALIZABLE      | No        | No             | No

Quick definitions:
  • Dirty read: reading uncommitted data.
  • Non-repeatable: re-reading the same row yields a different value.
  • Phantom: the same predicate returns more/fewer rows next time.

Example:
  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT ... ; -- a fixed snapshot for the whole transaction
  COMMIT;

PG uses MVCC snapshots, so REPEATABLE READ already prevents
phantoms too.',
'[]',20,380),

('n_pg_locking','Lock & Deadlock','Database',
'PostgreSQL khóa ở nhiều mức. Người ĐỌC thường không chặn người
GHI (nhờ MVCC), nhưng hai người GHI cùng hàng thì chờ nhau.

Khóa hàng chủ động:
  SELECT * FROM accounts WHERE id=1 FOR UPDATE;  -- giữ hàng để sửa
  SELECT ... FOR SHARE;                           -- chặn ghi, cho đọc

Deadlock: A giữ hàng 1 chờ hàng 2, B giữ hàng 2 chờ hàng 1.
PostgreSQL TỰ phát hiện và hủy một transaction (báo deadlock).

Tránh deadlock:
  • Luôn khóa các hàng theo CÙNG một thứ tự ở mọi nơi.
  • Giữ transaction NGẮN.
  • Dùng SELECT ... FOR UPDATE SKIP LOCKED cho hàng đợi công việc.',
'PostgreSQL locks at several levels. READERS usually do not block
WRITERS (thanks to MVCC), but two WRITERS on the same row wait for
each other.

Explicit row locks:
  SELECT * FROM accounts WHERE id=1 FOR UPDATE;  -- hold a row to edit
  SELECT ... FOR SHARE;                           -- block writes, allow reads

Deadlock: A holds row 1 waiting for row 2, B holds row 2 waiting
for row 1. PostgreSQL DETECTS this automatically and aborts one
transaction (reports a deadlock).

Avoiding deadlocks:
  • Always lock rows in the SAME order everywhere.
  • Keep transactions SHORT.
  • Use SELECT ... FOR UPDATE SKIP LOCKED for job queues.',
'[]',100,380),

('n_pg_txn','Transaction & Savepoint','Database',
'Transaction gom nhiều câu lệnh thành một đơn vị ACID: hoặc thành
công tất cả (COMMIT) hoặc hủy tất cả (ROLLBACK).

  BEGIN;
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
    UPDATE accounts SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- cả hai cùng thành công, nếu lỗi giữa chừng -> ROLLBACK

Savepoint — rollback một phần:
  BEGIN;
    INSERT ...;
    SAVEPOINT sp1;
    UPDATE ...;         -- lỡ lỗi
    ROLLBACK TO sp1;    -- chỉ hủy từ sp1, giữ INSERT
  COMMIT;

Lưu ý: transaction mở lâu giữ snapshot -> cản VACUUM dọn tuple chết.
Giữ giao dịch ngắn gọn.',
'A transaction groups statements into one ACID unit: either all
succeed (COMMIT) or all are undone (ROLLBACK).

  BEGIN;
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
    UPDATE accounts SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- both succeed together; on a mid-way error -> ROLLBACK

Savepoint - partial rollback:
  BEGIN;
    INSERT ...;
    SAVEPOINT sp1;
    UPDATE ...;         -- suppose this errors
    ROLLBACK TO sp1;    -- undo only from sp1, keep the INSERT
  COMMIT;

Note: a long-open transaction holds a snapshot -> it blocks VACUUM
from cleaning dead tuples. Keep transactions short.',
'[]',20,440),

-- ===== Section 4: Tính năng nâng cao =====
('n_pg_jsonb','JSONB','Database',
'JSONB lưu JSON ở dạng nhị phân đã phân giải -> truy vấn nhanh, hỗ
trợ index; khác json (lưu text nguyên văn, chậm khi truy vấn).

Toán tử hay dùng:
  data->''key''      -> lấy giá trị (trả jsonb)
  data->>''key''     -> lấy giá trị (trả text)
  data @> ''{...}''  -> chứa (containment)  -- dùng được GIN index

Ví dụ:
  CREATE TABLE products (id serial, data jsonb);
  CREATE INDEX idx_data ON products USING GIN (data);
  SELECT * FROM products
   WHERE data @> ''{"brand":"acme"}''
     AND (data->>''price'')::int > 100;

Dùng JSONB cho dữ liệu bán cấu trúc/linh hoạt; vẫn nên chuẩn hóa
những trường truy vấn/nối bảng nhiều.',
'JSONB stores JSON in a parsed binary form -> fast queries and
index support; unlike json (stores raw text, slow to query).

Common operators:
  data->''key''      -> get value (returns jsonb)
  data->>''key''     -> get value (returns text)
  data @> ''{...}''  -> containment  -- can use a GIN index

Example:
  CREATE TABLE products (id serial, data jsonb);
  CREATE INDEX idx_data ON products USING GIN (data);
  SELECT * FROM products
   WHERE data @> ''{"brand":"acme"}''
     AND (data->>''price'')::int > 100;

Use JSONB for semi-structured/flexible data; still normalize the
fields you frequently filter or join on.',
'[]',220,380),

('n_pg_cte_window','CTE & Window Functions','Database',
'CTE (WITH) đặt tên cho truy vấn con -> dễ đọc; hỗ trợ đệ quy.
Window function tính toán TRÊN một khung hàng mà KHÔNG gộp nhóm.

CTE:
  WITH recent AS (
    SELECT * FROM orders WHERE created_at > now() - interval ''7 days''
  )
  SELECT user_id, count(*) FROM recent GROUP BY user_id;

Window (giữ nguyên từng hàng, thêm cột tính toán):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC),
         avg(salary) OVER (PARTITION BY dept)
  FROM employees;

CTE đệ quy (duyệt cây/đồ thị):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id FROM cat WHERE id = 1
    UNION ALL
    SELECT c.id, c.parent_id FROM cat c JOIN tree t ON c.parent_id = t.id
  ) SELECT * FROM tree;',
'A CTE (WITH) names a subquery -> more readable; supports recursion.
A window function computes OVER a frame of rows WITHOUT collapsing
them into groups.

CTE:
  WITH recent AS (
    SELECT * FROM orders WHERE created_at > now() - interval ''7 days''
  )
  SELECT user_id, count(*) FROM recent GROUP BY user_id;

Window (keeps each row, adds computed columns):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC),
         avg(salary) OVER (PARTITION BY dept)
  FROM employees;

Recursive CTE (walk a tree/graph):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id FROM cat WHERE id = 1
    UNION ALL
    SELECT c.id, c.parent_id FROM cat c JOIN tree t ON c.parent_id = t.id
  ) SELECT * FROM tree;',
'[]',300,380),

('n_pg_types','Kiểu dữ liệu phong phú','Database',
'PostgreSQL nổi bật vì hệ kiểu giàu, giảm nhu cầu xử lý ở app:

  uuid            : khóa phân tán (gen_random_uuid())
  array           : mảng, vd int[] , text[]
  enum            : tập giá trị cố định
  range           : khoảng (int4range, tstzrange) + exclusion constraint
  hstore/jsonb    : key-value / tài liệu
  inet/cidr       : địa chỉ mạng
  tsvector        : full-text search

Ví dụ mảng + range:
  CREATE TABLE ev (id serial, tags text[], during tstzrange);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);
  -- chặn đặt phòng trùng giờ bằng exclusion constraint trên range

Có thể tự tạo type/domain riêng. Dùng đúng kiểu giúp ràng buộc dữ
liệu chặt và query gọn hơn.',
'PostgreSQL stands out for its rich type system, reducing app-side
handling:

  uuid            : distributed keys (gen_random_uuid())
  array           : arrays, e.g. int[] , text[]
  enum            : a fixed set of values
  range           : ranges (int4range, tstzrange) + exclusion constraint
  hstore/jsonb    : key-value / document
  inet/cidr       : network addresses
  tsvector        : full-text search

Array + range example:
  CREATE TABLE ev (id serial, tags text[], during tstzrange);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);
  -- prevent overlapping bookings via an exclusion constraint on the range

You can define custom types/domains. Using the right type enforces
data constraints tightly and keeps queries cleaner.',
'[]',220,440),

('n_pg_partition','Partitioning','Database',
'Partitioning chia một bảng lớn thành nhiều bảng con theo khóa,
giúp query chỉ quét phần liên quan (partition pruning) và bảo trì
dễ (xóa cả partition cũ thay vì DELETE hàng loạt).

Kiểu phân mảnh:
  RANGE  : theo khoảng (vd theo tháng/ngày) — phổ biến cho log
  LIST   : theo danh sách giá trị (vd theo quốc gia)
  HASH   : chia đều theo băm

Ví dụ RANGE theo thời gian:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);
  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');

Planner tự loại các partition không khớp WHERE -> nhanh hơn nhiều
trên bảng cực lớn. Kết hợp BRIN index cho dữ liệu theo thời gian.',
'Partitioning splits a large table into child tables by a key, so
queries scan only the relevant part (partition pruning) and
maintenance is easy (drop a whole old partition instead of a mass
DELETE).

Partition kinds:
  RANGE  : by range (e.g. by month/day) - common for logs
  LIST   : by a list of values (e.g. by country)
  HASH   : evenly split by hash

RANGE by time example:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);
  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');

The planner prunes partitions that do not match WHERE -> much
faster on huge tables. Combine with a BRIN index for time-series
data.',
'[]',300,440)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_pg_part-of','root','t_pg','part-of'),
('e_t_pg_s_pg_1_part-of','t_pg','s_pg_1','part-of'),
('e_t_pg_s_pg_2_part-of','t_pg','s_pg_2','part-of'),
('e_t_pg_s_pg_3_part-of','t_pg','s_pg_3','part-of'),
('e_t_pg_s_pg_4_part-of','t_pg','s_pg_4','part-of'),
('e_s_pg_1_n_pg_arch','s_pg_1','n_pg_arch','part-of'),
('e_s_pg_1_n_pg_mvcc','s_pg_1','n_pg_mvcc','part-of'),
('e_s_pg_1_n_pg_wal','s_pg_1','n_pg_wal','part-of'),
('e_s_pg_1_n_pg_vacuum','s_pg_1','n_pg_vacuum','part-of'),
('e_s_pg_2_n_pg_btree','s_pg_2','n_pg_btree','part-of'),
('e_s_pg_2_n_pg_index_types','s_pg_2','n_pg_index_types','part-of'),
('e_s_pg_2_n_pg_explain','s_pg_2','n_pg_explain','part-of'),
('e_s_pg_2_n_pg_planner','s_pg_2','n_pg_planner','part-of'),
('e_s_pg_3_n_pg_isolation','s_pg_3','n_pg_isolation','part-of'),
('e_s_pg_3_n_pg_locking','s_pg_3','n_pg_locking','part-of'),
('e_s_pg_3_n_pg_txn','s_pg_3','n_pg_txn','part-of'),
('e_s_pg_4_n_pg_jsonb','s_pg_4','n_pg_jsonb','part-of'),
('e_s_pg_4_n_pg_cte_window','s_pg_4','n_pg_cte_window','part-of'),
('e_s_pg_4_n_pg_types','s_pg_4','n_pg_types','part-of'),
('e_s_pg_4_n_pg_partition','s_pg_4','n_pg_partition','part-of'),
('e_n_pg_mvcc_n_pg_vacuum_rel','n_pg_mvcc','n_pg_vacuum','related'),
('e_n_pg_btree_n_pg_explain_rel','n_pg_btree','n_pg_explain','related'),
('e_t_pg_q_8_related','t_pg','q_8','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
