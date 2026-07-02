-- ===================================================================
--  ĐÀO SÂU PostgreSQL (đợt 1a): MVCC, Isolation, Locking
--  Ghi đè description + description_en với ví dụ từng bước.
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_pg_deep.sql
-- ===================================================================

UPDATE kg_nodes SET
description=
'MVCC = mỗi UPDATE/DELETE KHÔNG ghi đè tại chỗ, mà tạo một PHIÊN BẢN
MỚI của hàng. Nhờ vậy người đọc và người ghi KHÔNG chặn nhau.

Mỗi hàng có 2 cột hệ thống ẩn:
  xmin = id transaction đã TẠO phiên bản này
  xmax = id transaction đã XÓA/thay thế nó (0 = còn sống)

VÍ DỤ TỪNG BƯỚC (2 phiên chạy song song):

  -- Xem cột ẩn:
  SELECT xmin, xmax, bal FROM acc WHERE id = 1;
  -- xmin=100  xmax=0  bal=500   (phiên bản hiện hành)

  Session A  (txid 205)              Session B  (txid 206)
  ----------------------             ----------------------
  BEGIN;
  UPDATE acc SET bal=400
    WHERE id=1;
   -- hàng cũ: xmax=205 (đánh dấu chết)
   -- hàng mới: xmin=205 bal=400
                                     BEGIN;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- 500 (A chưa COMMIT -> thấy bản cũ)
  COMMIT;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- READ COMMITTED  -> 400
                                     -- REPEATABLE READ -> vẫn 500

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi transaction có một txid tăng dần.
  2. Khi đọc, PostgreSQL so txid + trạng thái commit để quyết định
     phiên bản nào "nhìn thấy được" với mình (visibility).
  3. A chưa commit -> B thấy bản cũ (KHÔNG có dirty read).
  4. Hàng cũ chỉ bị ĐÁNH DẤU chết (xmax), chưa xóa vật lý -> VACUUM
     dọn sau. Đây là lý do bảng phình (bloat) nếu thiếu VACUUM.

Kết quả: đọc không cần khóa, không chặn ghi -> đồng thời (concurrency) cao.'
,description_en=
'MVCC = an UPDATE/DELETE does NOT overwrite in place; it creates a
NEW VERSION of the row. So readers and writers do NOT block each other.

Every row has 2 hidden system columns:
  xmin = id of the transaction that CREATED this version
  xmax = id of the transaction that DELETED/replaced it (0 = alive)

STEP-BY-STEP EXAMPLE (2 sessions running concurrently):

  -- Inspect the hidden columns:
  SELECT xmin, xmax, bal FROM acc WHERE id = 1;
  -- xmin=100  xmax=0  bal=500   (current version)

  Session A  (txid 205)              Session B  (txid 206)
  ----------------------             ----------------------
  BEGIN;
  UPDATE acc SET bal=400
    WHERE id=1;
   -- old row: xmax=205 (marked dead)
   -- new row: xmin=205 bal=400
                                     BEGIN;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- 500 (A not COMMITted -> sees old)
  COMMIT;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- READ COMMITTED  -> 400
                                     -- REPEATABLE READ -> still 500

STEP-BY-STEP EXPLANATION:
  1. Every transaction has an increasing txid.
  2. On read, PostgreSQL compares txid + commit status to decide which
     version is "visible" to it (visibility).
  3. A has not committed -> B sees the old version (NO dirty read).
  4. The old row is only MARKED dead (xmax), not physically deleted ->
     VACUUM cleans it later. That is why tables bloat without VACUUM.

Result: reads need no locks and do not block writes -> high concurrency.'
WHERE id='n_pg_mvcc';

UPDATE kg_nodes SET
description=
'Mức isolation quyết định một transaction thấy gì từ transaction khác.
PostgreSQL mặc định READ COMMITTED.

VÍ DỤ NON-REPEATABLE READ (ở READ COMMITTED):

  Session A                          Session B
  ---------                          ---------
  BEGIN;
  SELECT bal FROM acc WHERE id=1;    -- 500
                                     BEGIN;
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- 800  <- ĐỌC LẠI RA KHÁC!
  COMMIT;

Muốn A luôn thấy 500 suốt giao dịch -> dùng REPEATABLE READ:

  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT bal FROM acc WHERE id=1;  -- 500 (chụp snapshot tại đây)
    -- (B cập nhật 800 và COMMIT ở giữa)
    SELECT bal FROM acc WHERE id=1;  -- vẫn 500
  COMMIT;

BẢNG TÓM TẮT (mức nào chặn anomaly nào):
  Mức              | Dirty | Non-repeatable | Phantom
  -----------------|-------|----------------|--------
  READ COMMITTED   | chặn  | CÓ THỂ         | CÓ THỂ
  REPEATABLE READ  | chặn  | chặn           | chặn (PG dùng snapshot)
  SERIALIZABLE     | chặn  | chặn           | chặn + chống write-skew

GIẢI THÍCH TỪNG THUẬT NGỮ:
  • Dirty read     : đọc dữ liệu CHƯA commit (PG không bao giờ cho).
  • Non-repeatable : đọc lại CÙNG hàng ra giá trị khác.
  • Phantom        : cùng điều kiện WHERE, lần sau ra THÊM/BỚT hàng.
  • Write-skew     : 2 giao dịch đọc rồi ghi chéo, mỗi cái đúng riêng
                     nhưng cùng nhau phá bất biến -> chỉ SERIALIZABLE chặn.

Mức càng cao càng an toàn nhưng càng nhiều xung đột. SERIALIZABLE có
thể trả lỗi serialization -> ứng dụng phải RETRY giao dịch.'
,description_en=
'The isolation level decides what one transaction sees from others.
PostgreSQL defaults to READ COMMITTED.

NON-REPEATABLE READ EXAMPLE (under READ COMMITTED):

  Session A                          Session B
  ---------                          ---------
  BEGIN;
  SELECT bal FROM acc WHERE id=1;    -- 500
                                     BEGIN;
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- 800  <- RE-READ DIFFERS!
  COMMIT;

To make A always see 500 for the whole transaction -> REPEATABLE READ:

  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT bal FROM acc WHERE id=1;  -- 500 (snapshot taken here)
    -- (B updates to 800 and COMMITs in between)
    SELECT bal FROM acc WHERE id=1;  -- still 500
  COMMIT;

SUMMARY TABLE (which level prevents which anomaly):
  Level            | Dirty | Non-repeatable | Phantom
  -----------------|-------|----------------|--------
  READ COMMITTED   | no    | POSSIBLE       | POSSIBLE
  REPEATABLE READ  | no    | no             | no (PG uses a snapshot)
  SERIALIZABLE     | no    | no             | no + prevents write-skew

TERM-BY-TERM EXPLANATION:
  • Dirty read     : reading UNCOMMITTED data (PG never allows it).
  • Non-repeatable : re-reading the SAME row yields a different value.
  • Phantom        : same WHERE, next time returns MORE/FEWER rows.
  • Write-skew     : two transactions read then write across each other,
                     each valid alone but together break an invariant ->
                     only SERIALIZABLE prevents it.

Higher levels are safer but conflict more. SERIALIZABLE may return a
serialization error -> the app must RETRY the transaction.'
WHERE id='n_pg_isolation';

UPDATE kg_nodes SET
description=
'Người ĐỌC không chặn người GHI (nhờ MVCC). Nhưng hai người GHI cùng
một hàng thì phải chờ nhau.

KHÓA CHỦ ĐỘNG để cập nhật an toàn (chống lost update):

  BEGIN;
    SELECT * FROM acc WHERE id=1 FOR UPDATE;   -- giữ khóa hàng
    UPDATE acc SET bal = bal - 100 WHERE id=1;
  COMMIT;   -- giao dịch khác đụng id=1 phải CHỜ tới đây

VÍ DỤ DEADLOCK (khóa chéo do khác thứ tự):

  Session A                          Session B
  ---------                          ---------
  BEGIN;                             BEGIN;
  UPDATE acc SET bal=bal-100         UPDATE acc SET bal=bal-50
    WHERE id=1;  -- giữ khóa hàng 1    WHERE id=2;  -- giữ khóa hàng 2
  UPDATE acc SET ...                 UPDATE acc SET ...
    WHERE id=2;  -- CHỜ B nhả hàng 2   WHERE id=1;  -- CHỜ A nhả hàng 1
  --> vòng chờ! PostgreSQL tự phát hiện và hủy 1 giao dịch:
      ERROR: deadlock detected

CÁCH TRÁNH (từng bước):
  1. Luôn khóa các hàng theo CÙNG một thứ tự ở mọi nơi (vd id nhỏ
     trước) -> không bao giờ tạo được vòng chờ.
  2. Giữ transaction NGẮN, làm ít việc khi đang giữ khóa.
  3. Hàng đợi công việc: SELECT ... FOR UPDATE SKIP LOCKED
     -> nhiều worker bỏ qua hàng đang bị khóa, không giẫm chân nhau.
  4. Bắt lỗi deadlock (SQLSTATE 40P01) và RETRY giao dịch.

Phân biệt khóa:
  • FOR UPDATE : khóa ghi độc quyền hàng (người khác chờ).
  • FOR SHARE  : cho người khác đọc/khóa share, chặn ghi.'
,description_en=
'READERS do not block WRITERS (thanks to MVCC). But two WRITERS on the
same row must wait for each other.

EXPLICIT LOCK for a safe update (prevents lost update):

  BEGIN;
    SELECT * FROM acc WHERE id=1 FOR UPDATE;   -- hold the row lock
    UPDATE acc SET bal = bal - 100 WHERE id=1;
  COMMIT;   -- other transactions touching id=1 WAIT until here

DEADLOCK EXAMPLE (cross-locking due to different order):

  Session A                          Session B
  ---------                          ---------
  BEGIN;                             BEGIN;
  UPDATE acc SET bal=bal-100         UPDATE acc SET bal=bal-50
    WHERE id=1;  -- holds row 1        WHERE id=2;  -- holds row 2
  UPDATE acc SET ...                 UPDATE acc SET ...
    WHERE id=2;  -- WAITS for B         WHERE id=1;  -- WAITS for A
  --> a wait cycle! PostgreSQL detects it and aborts one transaction:
      ERROR: deadlock detected

HOW TO AVOID (step by step):
  1. Always lock rows in the SAME order everywhere (e.g. smaller id
     first) -> a wait cycle can never form.
  2. Keep transactions SHORT, do little work while holding locks.
  3. Job queues: SELECT ... FOR UPDATE SKIP LOCKED
     -> many workers skip already-locked rows and do not collide.
  4. Catch the deadlock error (SQLSTATE 40P01) and RETRY.

Lock types:
  • FOR UPDATE : exclusive write lock on the row (others wait).
  • FOR SHARE  : lets others read/share-lock, blocks writes.'
WHERE id='n_pg_locking';
