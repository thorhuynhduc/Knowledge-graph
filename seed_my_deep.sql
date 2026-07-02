-- ĐÀO SÂU MySQL (đợt 2a): InnoDB, B+Tree clustered, Locking
UPDATE kg_nodes SET
description=
'InnoDB là engine mặc định của MySQL: ACID, MVCC, khóa mức hàng.

SƠ ĐỒ thành phần:
  ┌ Buffer Pool (RAM) ┐  cache trang data + index (quan trọng nhất)
  │  data pages        │
  │  index pages       │
  └────────────────────┘
        │ đọc/ghi
        ▼
  ┌ Log & recovery ┐
  │ Redo log    -> ghi trước thay đổi, phục hồi sau crash (như WAL)
  │ Undo log    -> lưu bản CŨ của hàng -> phục vụ MVCC + ROLLBACK
  │ Doublewrite -> chống trang ghi dở (torn page) khi crash
  └────────────────┘
        │
        ▼
  file .ibd trên đĩa

LUỒNG GHI khi COMMIT (giống WAL của PostgreSQL):
  1. sửa trang trong Buffer Pool (RAM)
  2. ghi Redo log + flush khi COMMIT        [điểm bền vững]
  3. trang "bẩn" flush xuống .ibd sau (checkpoint)

CẤU HÌNH QUAN TRỌNG NHẤT:
  innodb_buffer_pool_size = 60-75% RAM   -- đòn bẩy hiệu năng lớn nhất
  innodb_flush_log_at_trx_commit = 1     -- 1: an toàn nhất (fsync mỗi commit)
                                         -- 2/0: nhanh hơn, có thể mất giao dịch
                                         --      cuối khi crash
  innodb_log_file_size = 512M            -- redo log lớn -> ít checkpoint hơn

Chẩn đoán: SHOW ENGINE INNODB STATUS; -> xem buffer pool, deadlock gần nhất.'
,description_en=
'InnoDB is the default MySQL engine: ACID, MVCC, row-level locking.

COMPONENT DIAGRAM:
  ┌ Buffer Pool (RAM) ┐  caches data + index pages (most important)
  │  data pages        │
  │  index pages       │
  └────────────────────┘
        │ read/write
        ▼
  ┌ Log & recovery ┐
  │ Redo log    -> logs changes ahead, recovers after crash (like WAL)
  │ Undo log    -> keeps OLD row versions -> powers MVCC + ROLLBACK
  │ Doublewrite -> protects against torn-page writes on crash
  └────────────────┘
        │
        ▼
  .ibd files on disk

WRITE FLOW ON COMMIT (like PostgreSQL WAL):
  1. modify the page in the Buffer Pool (RAM)
  2. write the Redo log + flush on COMMIT   [durability point]
  3. dirty pages flush to .ibd later (checkpoint)

MOST IMPORTANT CONFIG:
  innodb_buffer_pool_size = 60-75% RAM   -- the biggest performance lever
  innodb_flush_log_at_trx_commit = 1     -- 1: safest (fsync each commit)
                                         -- 2/0: faster, may lose the last
                                         --      transactions on a crash
  innodb_log_file_size = 512M            -- larger redo log -> fewer checkpoints

Diagnose: SHOW ENGINE INNODB STATUS; -> buffer pool, latest deadlock.'
WHERE id='n_my_innodb';

UPDATE kg_nodes SET
description=
'InnoDB lưu bảng NHƯ một B+Tree theo PRIMARY KEY (clustered index):
dữ liệu hàng nằm NGAY trong lá của cây PK. Khác PostgreSQL (heap riêng).

SƠ ĐỒ tra cứu qua secondary index (TỐN 2 BƯỚC):

  Secondary index (idx theo email)
     lá: email -> PRIMARY KEY         (KHÔNG phải con trỏ tới hàng)
                     │
                     ▼   (lookup lần 2 = bookmark lookup)
  Clustered index (theo PK)
     lá: PK -> TOÀN BỘ dữ liệu hàng

VÍ DỤ:
  CREATE TABLE users (
    id    BIGINT PRIMARY KEY AUTO_INCREMENT,   -- clustered theo id
    email VARCHAR(255),
    name  VARCHAR(100),
    INDEX idx_email (email)                     -- secondary index
  );

  SELECT name FROM users WHERE email = ''a@x.com'';
  -- Bước 1: tìm trong idx_email -> ra id (vd 42)
  -- Bước 2: tìm id=42 trong clustered index -> lấy cả hàng (có name)

HỆ QUẢ THỰC TẾ:
  • PK nên NHỎ và TĂNG DẦN (BIGINT AUTO_INCREMENT). PK ngẫu nhiên
    (UUID v4) -> chèn phân mảnh trang + phình MỌI secondary index (vì
    mỗi secondary đều ngầm chứa PK ở lá).
  • Muốn tránh bước 2 (bookmark lookup): dùng covering index (node kế).'
,description_en=
'InnoDB stores the table AS a B+Tree ordered by the PRIMARY KEY
(clustered index): row data lives RIGHT in the PK leaves. Unlike
PostgreSQL (a separate heap).

DIAGRAM of a secondary-index lookup (COSTS 2 STEPS):

  Secondary index (idx on email)
     leaf: email -> PRIMARY KEY       (NOT a pointer to the row)
                     │
                     ▼   (second lookup = bookmark lookup)
  Clustered index (by PK)
     leaf: PK -> the WHOLE row data

EXAMPLE:
  CREATE TABLE users (
    id    BIGINT PRIMARY KEY AUTO_INCREMENT,   -- clustered by id
    email VARCHAR(255),
    name  VARCHAR(100),
    INDEX idx_email (email)                     -- secondary index
  );

  SELECT name FROM users WHERE email = ''a@x.com'';
  -- Step 1: search idx_email -> get the id (e.g. 42)
  -- Step 2: search id=42 in the clustered index -> fetch the row (has name)

REAL-WORLD CONSEQUENCES:
  • The PK should be SMALL and INCREASING (BIGINT AUTO_INCREMENT). A
    random PK (UUID v4) -> fragmented page inserts + bloats EVERY
    secondary index (each secondary implicitly holds the PK in its leaf).
  • To avoid step 2 (the bookmark lookup): use a covering index (next node).'
WHERE id='n_my_btree';

UPDATE kg_nodes SET
description=
'InnoDB khóa mức HÀNG, nhưng ở REPEATABLE READ (mặc định) còn khóa cả
KHOẢNG TRỐNG để chống phantom.

3 LOẠI KHÓA:
  Record lock  : khóa đúng một hàng chỉ mục
  Gap lock     : khóa KHOẢNG giữa 2 giá trị index (chặn chèn vào giữa)
  Next-key lock: record + gap (mặc định ở REPEATABLE READ)

VÍ DỤ khóa để cập nhật an toàn:
  START TRANSACTION;
    SELECT * FROM acc WHERE id = 1 FOR UPDATE;   -- khóa hàng id=1
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
  COMMIT;   -- giao dịch khác đụng id=1 phải CHỜ tới đây

VÍ DỤ next-key lock chặn phantom (ở REPEATABLE READ):
  SELECT * FROM t WHERE age BETWEEN 20 AND 30 FOR UPDATE;
  -- khóa các hàng 20..30 VÀ khoảng trống -> giao dịch khác KHÔNG chèn
  --   được age=25 vào giữa -> không có phantom

VÍ DỤ DEADLOCK (khóa chéo thứ tự) + xử lý:
  Session A: UPDATE acc ... WHERE id=1;  rồi  WHERE id=2;
  Session B: UPDATE acc ... WHERE id=2;  rồi  WHERE id=1;
  --> InnoDB phát hiện, rollback giao dịch RẺ hơn:
      ERROR 1213 (40001): Deadlock found when trying to get lock
  --> Ứng dụng nên BẮT lỗi 1213 và RETRY giao dịch.

TRÁNH: khóa theo CÙNG thứ tự; transaction NGẮN; có index đúng để giảm
số hàng bị khóa (thiếu index -> InnoDB khóa lan rộng rất nhiều hàng).'
,description_en=
'InnoDB locks at the ROW level, but under REPEATABLE READ (default) it
also locks GAPS to prevent phantoms.

3 LOCK TYPES:
  Record lock  : locks exactly one index row
  Gap lock     : locks the GAP between two index values (blocks inserts)
  Next-key lock: record + gap (default under REPEATABLE READ)

EXAMPLE of locking for a safe update:
  START TRANSACTION;
    SELECT * FROM acc WHERE id = 1 FOR UPDATE;   -- lock row id=1
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
  COMMIT;   -- other transactions touching id=1 WAIT until here

EXAMPLE of a next-key lock preventing phantoms (REPEATABLE READ):
  SELECT * FROM t WHERE age BETWEEN 20 AND 30 FOR UPDATE;
  -- locks rows 20..30 AND the gaps -> another transaction CANNOT insert
  --   age=25 in between -> no phantom

DEADLOCK EXAMPLE (cross-locking order) + handling:
  Session A: UPDATE acc ... WHERE id=1;  then  WHERE id=2;
  Session B: UPDATE acc ... WHERE id=2;  then  WHERE id=1;
  --> InnoDB detects it and rolls back the CHEAPER transaction:
      ERROR 1213 (40001): Deadlock found when trying to get lock
  --> The app should CATCH error 1213 and RETRY the transaction.

AVOID: lock in the SAME order; keep transactions SHORT; have proper
indexes to reduce locked rows (a missing index -> InnoDB locks many rows).'
WHERE id='n_my_locking';
