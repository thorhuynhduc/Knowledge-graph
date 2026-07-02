-- ===================================================================
--  TOPIC: MySQL Core (song ngữ VI + EN, ví dụ + sơ đồ)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_mysql.sql
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_mysql','MySQL Core','Database',
'Kiến thức chuyên sâu về MySQL/InnoDB: kiến trúc tầng + storage engine, index B+Tree (clustered/secondary), transaction & khóa (gap/next-key lock), MVCC, tối ưu truy vấn và replication. Kèm so sánh với PostgreSQL.',
'In-depth MySQL/InnoDB: layered architecture + storage engine, B+Tree indexes (clustered/secondary), transactions & locking (gap/next-key locks), MVCC, query tuning, and replication. Includes a comparison with PostgreSQL.',
'[]',1800,300),

('s_my_1','Kiến trúc & InnoDB','Database',
'Kiến trúc tầng của MySQL, storage engine, và nội tại InnoDB (buffer pool, redo/undo log).',
'The layered architecture of MySQL, storage engines, and InnoDB internals (buffer pool, redo/undo logs).',
'[]',1720,180),
('s_my_2','Index (B+Tree)','Database',
'Clustered vs secondary index, covering/composite index và cách đọc EXPLAIN.',
'Clustered vs secondary indexes, covering/composite indexes, and reading EXPLAIN.',
'[]',1900,180),
('s_my_3','Transaction & Locking','Database',
'Mức isolation, MVCC của InnoDB, và các loại khóa (row, gap, next-key).',
'Isolation levels, InnoDB MVCC, and lock types (row, gap, next-key).',
'[]',1720,440),
('s_my_4','Tối ưu & Vận hành','Database',
'Tối ưu truy vấn, slow query log, replication và so sánh với PostgreSQL.',
'Query tuning, the slow query log, replication, and a comparison with PostgreSQL.',
'[]',1900,440),

-- ===== Section 1 =====
('n_my_arch','Kiến trúc tầng & Storage Engine','Database',
'MySQL tách rõ 2 tầng: tầng SQL (chung) và tầng storage engine
(cắm được — pluggable). Đây là nét đặc trưng so với PostgreSQL.

SƠ ĐỒ:

  Client
    │  (giao thức MySQL)
    ▼
  ┌ SQL Layer (chung cho mọi engine) ───────────┐
  │  connection/thread, parser, optimizer, cache │
  └───────────────────────────────────────────────┘
    │  Handler API
    ▼
  ┌ Storage Engine (cắm được) ──────────────────┐
  │  InnoDB (mặc định, có transaction) | MyISAM  │
  └───────────────────────────────────────────────┘
    │
    ▼
  Files trên đĩa

Khác PostgreSQL (đa tiến trình), MySQL dùng ĐA LUỒNG: mỗi kết nối
là một thread trong cùng process -> nhẹ hơn khi nhiều kết nối,
nhưng vẫn nên dùng pool.',
'MySQL clearly separates 2 layers: the SQL layer (shared) and the
storage engine layer (pluggable). This is a defining trait versus
PostgreSQL.

DIAGRAM:

  Client
    │  (MySQL protocol)
    ▼
  ┌ SQL Layer (shared by all engines) ──────────┐
  │  connection/thread, parser, optimizer, cache │
  └───────────────────────────────────────────────┘
    │  Handler API
    ▼
  ┌ Storage Engine (pluggable) ─────────────────┐
  │  InnoDB (default, transactional) | MyISAM    │
  └───────────────────────────────────────────────┘
    │
    ▼
  Files on disk

Unlike PostgreSQL (multi-process), MySQL is MULTI-THREADED: each
connection is a thread within one process -> lighter with many
connections, but you should still use a pool.',
'[]',1680,120),

('n_my_innodb','InnoDB internals','Database',
'InnoDB là engine mặc định, có ACID, MVCC và khóa mức hàng.

Thành phần chính:
  Buffer Pool : cache trang dữ liệu + index trong RAM (cấu hình
                innodb_buffer_pool_size, quan trọng nhất cho hiệu năng)
  Redo log    : ghi trước thay đổi để phục hồi sau crash (giống WAL)
  Undo log    : lưu bản cũ của hàng -> phục vụ MVCC + rollback
  Doublewrite : chống trang ghi dở khi crash

Luồng ghi (tương tự WAL của PG):
  sửa trang trong buffer pool -> ghi redo log (bền khi commit)
  -> flush trang xuống đĩa sau (checkpoint)

Chỉnh innodb_buffer_pool_size ~ 60-75% RAM cho server chuyên DB là
đòn bẩy hiệu năng lớn nhất.',
'InnoDB is the default engine, providing ACID, MVCC, and row-level
locking.

Main components:
  Buffer Pool : caches data + index pages in RAM (configured by
                innodb_buffer_pool_size, the most important for perf)
  Redo log    : logs changes ahead for crash recovery (like WAL)
  Undo log    : keeps old row versions -> powers MVCC + rollback
  Doublewrite : protects against torn page writes on crash

Write flow (similar to PG WAL):
  modify a page in the buffer pool -> write the redo log (durable on
  commit) -> flush pages to disk later (checkpoint)

Setting innodb_buffer_pool_size ~ 60-75% of RAM on a dedicated DB
server is the biggest performance lever.',
'[]',1760,120),

('n_my_engines','InnoDB vs MyISAM','Database',
'Nhờ kiến trúc cắm engine, MySQL có nhiều engine; hai cái kinh điển:

  Tiêu chí       | InnoDB (mặc định)     | MyISAM (cũ)
  ---------------|-----------------------|--------------------
  Transaction    | Có (ACID)             | KHÔNG
  Khóa           | Mức hàng (row)        | Mức bảng (table)
  Khóa ngoại     | Có                    | Không
  Crash recovery | Có (redo log)         | Yếu
  Phù hợp        | OLTP, ghi nhiều       | đọc thuần, ít ghi

Kết luận: hầu như luôn dùng InnoDB. MyISAM chỉ còn ở hệ thống cũ
hoặc bảng chỉ đọc rất đơn giản. Các engine khác: MEMORY (RAM),
ARCHIVE (nén, chỉ ghi thêm).

Kiểm tra engine:
  SHOW TABLE STATUS WHERE Name = ''orders'';',
'Thanks to the pluggable-engine design, MySQL has several engines;
the two classic ones:

  Criteria       | InnoDB (default)      | MyISAM (legacy)
  ---------------|-----------------------|--------------------
  Transactions   | Yes (ACID)            | NO
  Locking        | Row-level             | Table-level
  Foreign keys   | Yes                   | No
  Crash recovery | Yes (redo log)        | Weak
  Best for       | OLTP, write-heavy     | read-only, few writes

Conclusion: almost always use InnoDB. MyISAM only remains in legacy
systems or very simple read-only tables. Other engines: MEMORY
(RAM), ARCHIVE (compressed, append-only).

Check the engine:
  SHOW TABLE STATUS WHERE Name = ''orders'';',
'[]',1680,180),

-- ===== Section 2: Index =====
('n_my_btree','Clustered vs Secondary index','Database',
'InnoDB lưu bảng NHƯ một B+Tree theo PRIMARY KEY — gọi là clustered
index: dữ liệu hàng nằm NGAY trong lá của cây PK. Đây là khác biệt
lớn với PostgreSQL (heap tách rời).

SƠ ĐỒ tra cứu qua secondary index:

  Secondary index (vd theo email)
     lá chứa: email -> PRIMARY KEY (không phải con trỏ hàng)
                          │
                          ▼  (lookup lần 2)
  Clustered index (theo PK)
     lá chứa: PK -> TOÀN BỘ dữ liệu hàng

=> Tra cứu qua secondary index tốn 2 bước (gọi là bookmark lookup).

HỆ QUẢ THỰC TẾ:
  • PK nên NHỎ và tăng dần (vd BIGINT AUTO_INCREMENT). PK ngẫu nhiên
    (UUID v4) làm chèn phân mảnh, phình secondary index.
  • Mọi secondary index đều ngầm chứa PK.',
'InnoDB stores the table AS a B+Tree ordered by the PRIMARY KEY -
the clustered index: the row data lives RIGHT in the leaves of the
PK tree. This is a big difference from PostgreSQL (a separate heap).

DIAGRAM of a lookup via a secondary index:

  Secondary index (e.g. by email)
     leaf holds: email -> PRIMARY KEY (not a row pointer)
                            │
                            ▼  (second lookup)
  Clustered index (by PK)
     leaf holds: PK -> the WHOLE row data

=> A lookup via a secondary index takes 2 steps (a bookmark lookup).

REAL-WORLD CONSEQUENCES:
  • The PK should be SMALL and increasing (e.g. BIGINT AUTO_INCREMENT).
    A random PK (UUID v4) causes fragmented inserts and bloats
    secondary indexes.
  • Every secondary index implicitly contains the PK.',
'[]',1860,120),

('n_my_covering','Covering & Composite index','Database',
'Composite index nhiều cột tuân luật TIỀN TỐ TRÁI NHẤT (leftmost
prefix): index (a,b,c) phục vụ WHERE a, (a,b), (a,b,c) — KHÔNG phục
vụ tốt WHERE b hay c đơn lẻ.

Covering index: index chứa ĐỦ mọi cột câu query cần -> đọc xong ở
index, KHỎI phải về clustered index (rất nhanh).

Ví dụ:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- COVERING (chỉ đọc index, EXPLAIN thấy "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- KHÔNG dùng được index tốt (bỏ qua cột đầu):
  SELECT * FROM orders WHERE status = ''paid'';

Thứ tự cột: đặt cột lọc bằng (=) trước, cột phạm vi (>, <) sau.',
'A multi-column composite index follows the LEFTMOST PREFIX rule:
index (a,b,c) serves WHERE a, (a,b), (a,b,c) - it does NOT serve
WHERE b or c alone well.

Covering index: an index that contains ALL columns the query needs
-> the read finishes at the index, NO trip back to the clustered
index (very fast).

Example:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- COVERING (index-only, EXPLAIN shows "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- Cannot use the index well (skips the first column):
  SELECT * FROM orders WHERE status = ''paid'';

Column order: put equality (=) columns first, range (>, <) columns
last.',
'[]',1940,120),

('n_my_explain','Đọc EXPLAIN (MySQL)','Database',
'EXPLAIN cho biết optimizer định thực thi thế nào. Các cột quan trọng:

  type   : kiểu truy cập, từ TỐT đến XẤU:
           const > eq_ref > ref > range > index > ALL
           (ALL = full table scan, thường cần tránh)
  key    : index thực sự được dùng (NULL = không dùng index)
  rows   : ước lượng số hàng phải đọc
  Extra  : "Using index" (covering, tốt),
           "Using filesort"/"Using temporary" (thường tốn kém)

Ví dụ:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  EXPLAIN ANALYZE SELECT ... ;   -- MySQL 8: có thời gian thực tế

Quy trình: thấy type=ALL trên bảng lớn -> thêm index; thấy
filesort/temporary -> cân nhắc index cho ORDER BY/GROUP BY.',
'EXPLAIN shows how the optimizer plans to execute. Key columns:

  type   : access type, from GOOD to BAD:
           const > eq_ref > ref > range > index > ALL
           (ALL = full table scan, usually to be avoided)
  key    : the index actually used (NULL = no index used)
  rows   : estimated number of rows to read
  Extra  : "Using index" (covering, good),
           "Using filesort"/"Using temporary" (often expensive)

Example:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  EXPLAIN ANALYZE SELECT ... ;   -- MySQL 8: shows real timing

Process: see type=ALL on a big table -> add an index; see
filesort/temporary -> consider an index for ORDER BY/GROUP BY.',
'[]',1860,180),

-- ===== Section 3: Transaction & Locking =====
('n_my_isolation','Isolation & MVCC (InnoDB)','Database',
'InnoDB mặc định REPEATABLE READ (khác PostgreSQL mặc định READ
COMMITTED). InnoDB dùng MVCC qua UNDO LOG + READ VIEW.

  READ COMMITTED  : mỗi câu lệnh thấy snapshot mới nhất đã commit
  REPEATABLE READ : cả transaction dùng CÙNG một read view
                    (đặt ở lần đọc đầu) -> đọc lặp lại nhất quán
  SERIALIZABLE    : biến SELECT thành khóa chia sẻ

Cơ chế MVCC: khi đọc, InnoDB dựng lại phiên bản hàng phù hợp với
read view bằng cách lần theo undo log -> người đọc không chặn ghi.

Ví dụ:
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  START TRANSACTION;  SELECT ... ;  COMMIT;

Điểm đặc biệt: REPEATABLE READ + gap lock giúp InnoDB chống phantom
trong nhiều trường hợp (xem node Locking).',
'InnoDB defaults to REPEATABLE READ (unlike PostgreSQL, which
defaults to READ COMMITTED). InnoDB does MVCC via the UNDO LOG +
a READ VIEW.

  READ COMMITTED  : each statement sees the latest committed snapshot
  REPEATABLE READ : the whole transaction uses the SAME read view
                    (taken at the first read) -> consistent repeated reads
  SERIALIZABLE    : turns SELECT into a shared lock

MVCC mechanism: on read, InnoDB reconstructs the row version that
matches the read view by walking the undo log -> readers do not
block writers.

Example:
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  START TRANSACTION;  SELECT ... ;  COMMIT;

Notable: REPEATABLE READ + gap locks let InnoDB prevent phantoms in
many cases (see the Locking node).',
'[]',1680,380),

('n_my_locking','Row / Gap / Next-key lock & Deadlock','Database',
'InnoDB khóa mức HÀNG, nhưng để chống phantom ở REPEATABLE READ nó
còn khóa cả KHOẢNG TRỐNG giữa các hàng.

  Record lock  : khóa đúng một hàng chỉ mục
  Gap lock     : khóa khoảng trống giữa 2 giá trị index (chặn chèn)
  Next-key lock: record lock + gap lock (mặc định ở REPEATABLE READ)

Ví dụ khóa để cập nhật an toàn:
  START TRANSACTION;
    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- khóa hàng
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
  COMMIT;

Deadlock: hai transaction chờ khóa của nhau. InnoDB tự phát hiện và
rollback transaction rẻ hơn (báo lỗi 1213). Ứng dụng nên RETRY.

Tránh: khóa theo cùng thứ tự, transaction ngắn, index đúng để giảm
số hàng bị khóa (thiếu index -> khóa lan rộng).',
'InnoDB locks at the ROW level, but to prevent phantoms under
REPEATABLE READ it also locks the GAPS between rows.

  Record lock  : locks exactly one index row
  Gap lock     : locks the gap between two index values (blocks inserts)
  Next-key lock: record lock + gap lock (default under REPEATABLE READ)

Example of locking for a safe update:
  START TRANSACTION;
    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- lock the row
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
  COMMIT;

Deadlock: two transactions wait on each other locks. InnoDB detects
it and rolls back the cheaper one (error 1213). The app should RETRY.

Avoid: lock in the same order, keep transactions short, and have
proper indexes to reduce locked rows (a missing index -> locks
spread widely).',
'[]',1760,380),

-- ===== Section 4: Tối ưu & Vận hành =====
('n_my_optimize','Tối ưu truy vấn & Slow query log','Database',
'Quy trình tối ưu thực dụng:

  1. Bật slow query log để tìm truy vấn chậm:
       SET GLOBAL slow_query_log = ON;
       SET GLOBAL long_query_time = 1;   -- >1s bị ghi lại
  2. Chạy EXPLAIN để xem type/key/rows/Extra.
  3. Thêm index đúng (composite, covering) theo mẫu WHERE/ORDER BY.
  4. Tránh anti-pattern:
       • N+1 query (vòng lặp truy vấn) -> JOIN hoặc IN (...)
       • SELECT *  -> chỉ chọn cột cần (tận dụng covering index)
       • Hàm bọc cột: WHERE DATE(created_at)=... -> index vô dụng
       • OFFSET lớn khi phân trang -> dùng keyset pagination
         (WHERE id > last_id LIMIT n)

Đo lại sau mỗi thay đổi; đừng thêm index tràn lan (index làm chậm
ghi và tốn dung lượng).',
'A practical tuning workflow:

  1. Enable the slow query log to find slow queries:
       SET GLOBAL slow_query_log = ON;
       SET GLOBAL long_query_time = 1;   -- >1s is logged
  2. Run EXPLAIN to inspect type/key/rows/Extra.
  3. Add the right index (composite, covering) matching your
     WHERE/ORDER BY shape.
  4. Avoid anti-patterns:
       • N+1 queries (querying in a loop) -> JOIN or IN (...)
       • SELECT *  -> select only needed columns (enable covering)
       • Function-wrapped columns: WHERE DATE(created_at)=... -> index unused
       • Large OFFSET pagination -> use keyset pagination
         (WHERE id > last_id LIMIT n)

Measure again after each change; do not add indexes everywhere
(indexes slow writes and cost space).',
'[]',1860,380),

('n_my_replication','Replication','Database',
'Replication sao chép dữ liệu từ primary (source) sang replica dựa
trên BINLOG — nhật ký ghi lại mọi thay đổi.

SƠ ĐỒ:
  Primary --(binlog)--> Replica I/O thread --> relay log
                                                   │
                                          Replica SQL thread applies
                                                   ▼
                                             Replica data

Chế độ bền vững:
  • Async (mặc định)  : primary không chờ replica -> nhanh, nhưng
    có thể mất dữ liệu nếu primary sập trước khi replica nhận kịp.
  • Semi-sync         : primary chờ ÍT NHẤT 1 replica xác nhận đã
    nhận -> an toàn hơn, chậm hơn chút.

Dùng để: mở rộng đọc (đọc từ replica), backup, và failover (nâng
replica lên primary). Lưu ý độ trễ replica (replication lag) khi
đọc-sau-ghi.',
'Replication copies data from a primary (source) to replicas based
on the BINLOG - a log recording every change.

DIAGRAM:
  Primary --(binlog)--> Replica I/O thread --> relay log
                                                   │
                                          Replica SQL thread applies
                                                   ▼
                                             Replica data

Durability modes:
  • Async (default)  : the primary does not wait for the replica ->
    fast, but data may be lost if the primary crashes before the
    replica catches up.
  • Semi-sync        : the primary waits for AT LEAST 1 replica to
    acknowledge receipt -> safer, slightly slower.

Used for: read scaling (read from replicas), backups, and failover
(promote a replica to primary). Watch replication lag for
read-after-write consistency.',
'[]',1940,380),

('n_my_pg_vs_my','PostgreSQL vs MySQL','Database',
'Cả hai đều là RDBMS mạnh; chọn theo nhu cầu.

  Tiêu chí        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Kiến trúc       | đa tiến trình           | đa luồng
  Lưu bảng        | heap + index tách       | clustered theo PK
  Isolation mặc   | READ COMMITTED          | REPEATABLE READ
  Kiểu dữ liệu    | rất giàu (JSONB, array, | cơ bản + JSON
                  | range, GIS, custom type)|
  Tính năng SQL   | mạnh (CTE đệ quy, window,| đủ dùng (đã cải thiện
                  | index nâng cao)         | nhiều ở 8.0)
  Nổi bật         | chuẩn SQL, phân tích,    | đơn giản, phổ biến,
                  | dữ liệu phức tạp         | đọc nhanh, hệ sinh thái

Chọn nhanh:
  • Cần kiểu dữ liệu/truy vấn phức tạp, phân tích -> PostgreSQL.
  • Web app phổ thông, đọc nhiều, quen thuộc, nhiều hosting -> MySQL.
Cả hai đều đáp ứng tốt phần lớn dự án; sự khác biệt chỉ rõ ở quy mô
lớn hoặc yêu cầu đặc thù.',
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
  Strengths       | SQL-standard, analytics,| simple, popular,
                  | complex data            | fast reads, ecosystem

Quick pick:
  • Need complex data types/queries or analytics -> PostgreSQL.
  • Common web app, read-heavy, familiar, lots of hosting -> MySQL.
Both serve most projects well; differences mainly show at large
scale or special requirements.',
'[]',1860,440)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_mysql_part-of','root','t_mysql','part-of'),
('e_t_mysql_s_my_1_part-of','t_mysql','s_my_1','part-of'),
('e_t_mysql_s_my_2_part-of','t_mysql','s_my_2','part-of'),
('e_t_mysql_s_my_3_part-of','t_mysql','s_my_3','part-of'),
('e_t_mysql_s_my_4_part-of','t_mysql','s_my_4','part-of'),
('e_s_my_1_n_my_arch','s_my_1','n_my_arch','part-of'),
('e_s_my_1_n_my_innodb','s_my_1','n_my_innodb','part-of'),
('e_s_my_1_n_my_engines','s_my_1','n_my_engines','part-of'),
('e_s_my_2_n_my_btree','s_my_2','n_my_btree','part-of'),
('e_s_my_2_n_my_covering','s_my_2','n_my_covering','part-of'),
('e_s_my_2_n_my_explain','s_my_2','n_my_explain','part-of'),
('e_s_my_3_n_my_isolation','s_my_3','n_my_isolation','part-of'),
('e_s_my_3_n_my_locking','s_my_3','n_my_locking','part-of'),
('e_s_my_4_n_my_optimize','s_my_4','n_my_optimize','part-of'),
('e_s_my_4_n_my_replication','s_my_4','n_my_replication','part-of'),
('e_s_my_4_n_my_pg_vs_my','s_my_4','n_my_pg_vs_my','part-of'),
('e_n_my_pg_vs_my_t_pg_related','n_my_pg_vs_my','t_pg','related'),
('e_n_my_innodb_n_my_btree_rel','n_my_innodb','n_my_btree','related'),
('e_t_mysql_q_8_related','t_mysql','q_8','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
