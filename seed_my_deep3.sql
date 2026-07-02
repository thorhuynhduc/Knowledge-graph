-- ĐÀO SÂU MySQL (đợt 2c): Kiến trúc, Engines, Optimize, Replication, PG vs MySQL
UPDATE kg_nodes SET
description=
'MySQL tách rõ 2 tầng: SQL layer (chung) + storage engine (cắm được).

SƠ ĐỒ + vòng đời một query:
  Client
    │ (giao thức MySQL; mỗi kết nối = 1 THREAD)
    ▼
  ┌ SQL Layer (chung mọi engine) ─────────────────┐
  │ 1. Connection / thread                          │
  │ 2. Parser     (phân tích cú pháp SQL)           │
  │ 3. Optimizer  (chọn kế hoạch, chọn index)       │
  │ 4. Executor   (query cache đã bỏ từ MySQL 8)    │
  └─────────────────────────────────────────────────┘
    │ Handler API
    ▼
  ┌ Storage Engine (cắm được) ────────────────────┐
  │ InnoDB (mặc định, transaction) | MyISAM | MEMORY│
  └─────────────────────────────────────────────────┘
    │
    ▼
  file trên đĩa (.ibd với InnoDB)

KHÁC PostgreSQL:
  • MySQL       : ĐA LUỒNG (mỗi kết nối = 1 thread trong 1 process)
                  -> nhẹ hơn khi có nhiều kết nối.
  • PostgreSQL  : đa TIẾN TRÌNH (mỗi kết nối = 1 process).

Dù nhẹ hơn, vẫn nên dùng connection pool ở tầng app (vd pool của mysql2)
để tái dùng kết nối, tránh chi phí bắt tay lặp lại.'
,description_en=
'MySQL clearly separates 2 layers: the SQL layer (shared) + the storage
engine (pluggable).

DIAGRAM + one query lifecycle:
  Client
    │ (MySQL protocol; each connection = 1 THREAD)
    ▼
  ┌ SQL Layer (shared by all engines) ────────────┐
  │ 1. Connection / thread                          │
  │ 2. Parser     (parse the SQL)                   │
  │ 3. Optimizer  (choose the plan, pick indexes)   │
  │ 4. Executor   (query cache removed in MySQL 8)  │
  └─────────────────────────────────────────────────┘
    │ Handler API
    ▼
  ┌ Storage Engine (pluggable) ───────────────────┐
  │ InnoDB (default, transactional) | MyISAM | MEMORY│
  └─────────────────────────────────────────────────┘
    │
    ▼
  files on disk (.ibd for InnoDB)

VERSUS PostgreSQL:
  • MySQL       : MULTI-THREADED (each connection = a thread in one
                  process) -> lighter with many connections.
  • PostgreSQL  : MULTI-PROCESS (each connection = a process).

Even so, use a connection pool in the app (e.g. the mysql2 pool) to
reuse connections and avoid repeated handshake cost.'
WHERE id='n_my_arch';

UPDATE kg_nodes SET
description=
'Nhờ kiến trúc cắm engine, MySQL có nhiều storage engine; 2 cái kinh điển:

  Tiêu chí       | InnoDB (mặc định)  | MyISAM (cũ)
  ---------------|--------------------|--------------------
  Transaction    | Có (ACID)          | KHÔNG
  Khóa           | Mức HÀNG (row)     | Mức BẢNG (table)
  Khóa ngoại     | Có                 | Không
  Crash recovery | Có (redo log)      | Yếu
  Phù hợp        | OLTP, ghi nhiều    | đọc thuần, ít ghi

VÍ DỤ chọn / kiểm tra engine:
  CREATE TABLE t (...) ENGINE=InnoDB;         -- luôn ưu tiên InnoDB
  SHOW TABLE STATUS WHERE Name = ''orders'';   -- xem Engine hiện tại
  ALTER TABLE old_tbl ENGINE=InnoDB;          -- chuyển MyISAM -> InnoDB

TẠI SAO gần như LUÔN dùng InnoDB:
  • Khóa mức BẢNG của MyISAM -> một lệnh ghi khóa cả bảng -> nghẽn nặng
    khi tải cao.
  • MyISAM dễ mất dữ liệu khi crash (không có transaction log bền vững).

Engine khác: MEMORY (bảng trong RAM, mất khi restart), ARCHIVE (nén,
chỉ ghi thêm). MyISAM nay chỉ còn ở hệ thống cũ hoặc bảng chỉ đọc.'
,description_en=
'Thanks to the pluggable-engine design, MySQL has several storage
engines; the two classic ones:

  Criteria       | InnoDB (default)   | MyISAM (legacy)
  ---------------|--------------------|--------------------
  Transactions   | Yes (ACID)         | NO
  Locking        | ROW level          | TABLE level
  Foreign keys   | Yes                | No
  Crash recovery | Yes (redo log)     | Weak
  Best for       | OLTP, write-heavy  | read-only, few writes

CHOOSE / CHECK the engine:
  CREATE TABLE t (...) ENGINE=InnoDB;         -- always prefer InnoDB
  SHOW TABLE STATUS WHERE Name = ''orders'';   -- see the current Engine
  ALTER TABLE old_tbl ENGINE=InnoDB;          -- convert MyISAM -> InnoDB

WHY almost ALWAYS InnoDB:
  • MyISAM TABLE-level locking -> one write locks the whole table ->
    severe contention under load.
  • MyISAM loses data easily on crash (no durable transaction log).

Other engines: MEMORY (RAM tables, lost on restart), ARCHIVE (compressed,
append-only). MyISAM now only remains in legacy or read-only tables.'
WHERE id='n_my_engines';

UPDATE kg_nodes SET
description=
'QUY TRÌNH TỐI ƯU thực dụng:

1) BẬT slow query log để tìm câu chậm:
   SET GLOBAL slow_query_log = ON;
   SET GLOBAL long_query_time = 1;      -- ghi lại câu chạy > 1 giây

2) EXPLAIN xem type / key / rows / Extra (xem node EXPLAIN).

3) THÊM index đúng theo mẫu WHERE / ORDER BY (composite, covering).

4) TRÁNH anti-pattern (kèm cách sửa):

   • N+1 query (truy vấn trong vòng lặp):
       ✗ lặp mỗi user rồi chạy SELECT ... WHERE user_id = ?
       ✓ gộp 1 truy vấn: WHERE user_id IN (...)  hoặc dùng JOIN

   • SELECT * :
       ✗ SELECT * FROM orders
       ✓ SELECT id, amount     -- ít cột -> tận dụng covering index

   • Hàm bọc quanh cột (làm index vô dụng):
       ✗ WHERE DATE(created_at) = ''2026-01-01''
       ✓ WHERE created_at >= ''2026-01-01''
             AND created_at <  ''2026-01-02''

   • Phân trang OFFSET lớn (càng sâu càng chậm):
       ✗ ... ORDER BY id LIMIT 100000, 20
       ✓ keyset: WHERE id > :last_id ORDER BY id LIMIT 20

Đo lại sau MỖI thay đổi. Đừng thêm index tràn lan (index làm chậm ghi
và tốn dung lượng).'
,description_en=
'A practical TUNING workflow:

1) ENABLE the slow query log to find slow statements:
   SET GLOBAL slow_query_log = ON;
   SET GLOBAL long_query_time = 1;      -- log statements running > 1s

2) EXPLAIN to inspect type / key / rows / Extra (see the EXPLAIN node).

3) ADD the right index matching the WHERE / ORDER BY shape (composite,
   covering).

4) AVOID anti-patterns (with fixes):

   • N+1 queries (querying in a loop):
       WRONG loop each user then run SELECT ... WHERE user_id = ?
       RIGHT one query: WHERE user_id IN (...)  or use a JOIN

   • SELECT * :
       WRONG SELECT * FROM orders
       RIGHT SELECT id, amount     -- fewer columns -> enable covering

   • Function wrapped around a column (makes the index useless):
       WRONG WHERE DATE(created_at) = ''2026-01-01''
       RIGHT WHERE created_at >= ''2026-01-01''
                 AND created_at <  ''2026-01-02''

   • Large OFFSET pagination (deeper = slower):
       WRONG ... ORDER BY id LIMIT 100000, 20
       RIGHT keyset: WHERE id > :last_id ORDER BY id LIMIT 20

Measure after EACH change. Do not add indexes everywhere (indexes slow
writes and cost space).'
WHERE id='n_my_optimize';

UPDATE kg_nodes SET
description=
'Replication sao chép dữ liệu từ primary sang replica dựa trên BINLOG
(nhật ký ghi lại mọi thay đổi).

SƠ ĐỒ:
  Primary --(binlog)--> [Replica I/O thread] --> relay log
                                                    │
                                       [Replica SQL thread] áp dụng
                                                    ▼
                                              dữ liệu replica

CHẾ ĐỘ BỀN VỮNG:
  • Async (mặc định) : primary KHÔNG chờ replica -> nhanh, nhưng có thể
    mất dữ liệu nếu primary sập trước khi replica nhận kịp.
  • Semi-sync        : primary chờ ÍT NHẤT 1 replica xác nhận đã NHẬN
    (ghi relay log) -> an toàn hơn, chậm hơn chút.

FORMAT binlog:
  ROW (khuyến nghị) : ghi thay đổi từng HÀNG -> an toàn, chính xác.
  STATEMENT         : ghi câu SQL -> gọn nhưng rủi ro với hàm không xác
                      định (NOW(), RAND()).

DÙNG ĐỂ:
  • Mở rộng ĐỌC: app đọc từ replica, ghi vào primary (read/write split).
  • Backup, và failover (nâng replica lên primary khi primary sập).

LƯU Ý replication lag: replica có thể TRỄ -> tình huống đọc-sau-ghi
(read your own write) nên đọc từ primary hoặc chờ đồng bộ.'
,description_en=
'Replication copies data from a primary to replicas based on the BINLOG
(a log recording every change).

DIAGRAM:
  Primary --(binlog)--> [Replica I/O thread] --> relay log
                                                    │
                                       [Replica SQL thread] applies
                                                    ▼
                                              replica data

DURABILITY MODES:
  • Async (default)  : the primary does NOT wait for a replica -> fast,
    but data may be lost if the primary crashes before the replica catches up.
  • Semi-sync        : the primary waits for AT LEAST 1 replica to
    acknowledge receipt (relay log written) -> safer, slightly slower.

BINLOG FORMAT:
  ROW (recommended) : logs per-ROW changes -> safe, precise.
  STATEMENT         : logs the SQL text -> compact but risky with
                      non-deterministic functions (NOW(), RAND()).

USED FOR:
  • Read scaling: the app reads from replicas, writes to the primary
    (read/write split).
  • Backups, and failover (promote a replica to primary when it dies).

MIND replication lag: a replica may LAG -> for read-your-own-write cases,
read from the primary or wait for sync.'
WHERE id='n_my_replication';

UPDATE kg_nodes SET
description=
'Cả hai đều là RDBMS mạnh; chọn theo nhu cầu.

  Tiêu chí        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Kiến trúc       | đa tiến trình           | đa luồng
  Lưu bảng        | heap + index tách rời   | clustered theo PK
  Isolation mặc   | READ COMMITTED          | REPEATABLE READ
  Kiểu dữ liệu    | rất giàu (JSONB, array, | cơ bản + JSON
                  | range, GIS, custom)     |
  Tính năng SQL   | mạnh (CTE đệ quy, window| đủ dùng (cải thiện
                  | , index nâng cao)       | nhiều ở 8.0)
  Vận hành        | cần VACUUM (dead tuple) | chọn PK tăng dần

KHI NÀO CHỌN (kịch bản cụ thể):
  • Phân tích, truy vấn phức tạp, window, CTE đệ quy      -> PostgreSQL
  • Dữ liệu địa lý (PostGIS), JSONB nặng, kiểu tùy biến   -> PostgreSQL
  • Web app phổ thông, đọc nhiều, đội quen MySQL, hosting -> MySQL
  • Cần khóa ngoại + transaction chuẩn: cả hai đều tốt

Kết: khác biệt chỉ RÕ ở quy mô lớn hoặc yêu cầu đặc thù; đa số dự án
cả hai đều đáp ứng tốt. Điểm chung: đều là SQL/ACID, có MVCC, index,
replication, transaction.'
,description_en=
'Both are powerful RDBMSs; choose by need.

  Criteria        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Architecture    | multi-process           | multi-threaded
  Table storage   | heap + separate index   | clustered by PK
  Default isolation| READ COMMITTED         | REPEATABLE READ
  Data types      | very rich (JSONB, array,| basic + JSON
                  | range, GIS, custom)     |
  SQL features    | strong (recursive CTE,  | sufficient (much
                  | window, advanced index) | improved in 8.0)
  Operations      | needs VACUUM (dead tuples)| use an increasing PK

WHEN TO CHOOSE (concrete scenarios):
  • Analytics, complex queries, window, recursive CTE    -> PostgreSQL
  • Geospatial (PostGIS), heavy JSONB, custom types      -> PostgreSQL
  • Common web app, read-heavy, MySQL-familiar team, hosting -> MySQL
  • Need foreign keys + standard transactions: both are good

Conclusion: differences mainly show at large scale or special needs;
both serve most projects well. In common: SQL/ACID, MVCC, indexes,
replication, transactions.'
WHERE id='n_my_pg_vs_my';
