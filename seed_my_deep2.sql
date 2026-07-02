-- ĐÀO SÂU MySQL (đợt 2b): Isolation, EXPLAIN, Covering index
UPDATE kg_nodes SET
description=
'InnoDB mặc định REPEATABLE READ (khác PostgreSQL mặc định READ
COMMITTED). Dùng MVCC qua UNDO LOG + READ VIEW.

4 MỨC:
  READ UNCOMMITTED : cho dirty read (hầu như không dùng)
  READ COMMITTED   : mỗi câu lệnh thấy snapshot mới nhất đã commit
  REPEATABLE READ  : cả transaction dùng CÙNG một read view (chụp ở lần
                     đọc đầu) -> đọc lặp lại nhất quán   [MẶC ĐỊNH]
  SERIALIZABLE     : biến SELECT thành khóa chia sẻ (chặt nhất)

CƠ CHẾ MVCC: khi đọc, InnoDB dựng lại phiên bản hàng khớp read view
bằng cách lần theo UNDO LOG -> người đọc không chặn người ghi.

VÍ DỤ READ COMMITTED vs REPEATABLE READ:
  Session A                          Session B
  ---------                          ---------
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  START TRANSACTION;
  SELECT bal FROM acc WHERE id=1;    -- 500 (chụp read view tại đây)
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- VẪN 500 (cùng read view)
  COMMIT;
  -- Nếu đổi sang READ COMMITTED: lần đọc thứ 2 sẽ ra 800.

ĐIỂM ĐẶC BIỆT: REPEATABLE READ + gap lock giúp InnoDB chống phantom
trong nhiều trường hợp (khác lý thuyết SQL chuẩn, nơi RR vẫn có phantom).'
,description_en=
'InnoDB defaults to REPEATABLE READ (unlike PostgreSQL, which defaults
to READ COMMITTED). It does MVCC via the UNDO LOG + a READ VIEW.

4 LEVELS:
  READ UNCOMMITTED : allows dirty reads (rarely used)
  READ COMMITTED   : each statement sees the latest committed snapshot
  REPEATABLE READ  : the whole transaction uses the SAME read view (taken
                     at the first read) -> consistent repeated reads [DEFAULT]
  SERIALIZABLE     : turns SELECT into a shared lock (strictest)

MVCC MECHANISM: on read, InnoDB reconstructs the row version matching the
read view by walking the UNDO LOG -> readers do not block writers.

READ COMMITTED vs REPEATABLE READ EXAMPLE:
  Session A                          Session B
  ---------                          ---------
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  START TRANSACTION;
  SELECT bal FROM acc WHERE id=1;    -- 500 (read view taken here)
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- STILL 500 (same read view)
  COMMIT;
  -- Under READ COMMITTED: the second read would return 800.

NOTABLE: REPEATABLE READ + gap locks let InnoDB prevent phantoms in many
cases (unlike the SQL standard theory, where RR still allows phantoms).'
WHERE id='n_my_isolation';

UPDATE kg_nodes SET
description=
'EXPLAIN cho biết optimizer định thực thi ra sao.

  EXPLAIN SELECT * FROM orders WHERE user_id = 42;

  id  select_type  table   type  key       rows  Extra
  1   SIMPLE       orders  ref   idx_user   5    Using where

Ý NGHĨA CÁC CỘT:
  type  : kiểu truy cập, TỐT -> XẤU:
          system > const > eq_ref > ref > range > index > ALL
          (ALL = full table scan -> cần tránh trên bảng lớn)
  key   : index THỰC SỰ được dùng (NULL = không dùng index nào)
  rows  : ước lượng số hàng phải đọc (càng nhỏ càng tốt)
  Extra : "Using index"     -> covering index (rất tốt, khỏi đọc bảng)
          "Using where"     -> lọc thêm sau khi đọc
          "Using filesort"  -> phải sắp xếp riêng (tốn kém)
          "Using temporary" -> tạo bảng tạm (tốn kém)

MySQL 8 có EXPLAIN ANALYZE (chạy THẬT + thời gian thực tế):
  EXPLAIN ANALYZE SELECT ... ;
  -- ... (actual time=0.1..0.3 rows=5 loops=1) ...

QUY TRÌNH:
  • type=ALL trên bảng lớn    -> thêm index cho cột lọc.
  • Using filesort/temporary  -> thêm index phục vụ ORDER BY / GROUP BY.
  • rows lớn bất thường        -> ANALYZE TABLE để cập nhật thống kê.'
,description_en=
'EXPLAIN shows how the optimizer plans to execute.

  EXPLAIN SELECT * FROM orders WHERE user_id = 42;

  id  select_type  table   type  key       rows  Extra
  1   SIMPLE       orders  ref   idx_user   5    Using where

MEANING OF THE COLUMNS:
  type  : access type, GOOD -> BAD:
          system > const > eq_ref > ref > range > index > ALL
          (ALL = full table scan -> avoid on large tables)
  key   : the index actually used (NULL = no index used)
  rows  : estimated rows to read (smaller is better)
  Extra : "Using index"     -> covering index (great, no table read)
          "Using where"     -> extra filtering after the read
          "Using filesort"  -> a separate sort (expensive)
          "Using temporary" -> a temp table (expensive)

MySQL 8 has EXPLAIN ANALYZE (actually RUNS it + real timing):
  EXPLAIN ANALYZE SELECT ... ;
  -- ... (actual time=0.1..0.3 rows=5 loops=1) ...

PROCESS:
  • type=ALL on a big table  -> add an index on the filter column.
  • Using filesort/temporary -> add an index for ORDER BY / GROUP BY.
  • unusually large rows      -> ANALYZE TABLE to refresh statistics.'
WHERE id='n_my_explain';

UPDATE kg_nodes SET
description=
'Composite index tuân luật TIỀN TỐ TRÁI NHẤT (leftmost prefix). Covering
index chứa ĐỦ cột mà query cần -> đọc xong NGAY ở index, KHÔNG cần về
clustered index (rất nhanh; EXPLAIN báo "Using index").

VÍ DỤ:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- ✓ COVERING (chỉ đọc index, Extra = "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- ✓ Dùng được index (leftmost prefix):
  WHERE user_id = 42
  WHERE user_id = 42 AND status = ''paid''

  -- ✗ KHÔNG dùng tốt (bỏ cột đầu user_id):
  WHERE status = ''paid''
  WHERE amount > 100

THỨ TỰ CỘT (nguyên tắc):
  1. Cột lọc bằng (=) đặt TRƯỚC.
  2. Cột phạm vi (>, <, BETWEEN) đặt SAU (sau một cột range, các cột
     tiếp theo không còn dùng được để tìm kiếm nữa).
  3. Thêm cột trong SELECT vào index -> biến thành covering.

TỐI ƯU ORDER BY:
  -- index (user_id, created_at) phục vụ:
  SELECT * FROM orders WHERE user_id=42 ORDER BY created_at DESC;
  -- KHÔNG cần filesort vì index đã sắp sẵn theo created_at.'
,description_en=
'A composite index follows the LEFTMOST PREFIX rule. A covering index
contains ALL columns the query needs -> the read finishes AT the index,
NO trip to the clustered index (very fast; EXPLAIN shows "Using index").

EXAMPLE:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- OK COVERING (index-only, Extra = "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- OK uses the index (leftmost prefix):
  WHERE user_id = 42
  WHERE user_id = 42 AND status = ''paid''

  -- NO does not use it well (skips the first column user_id):
  WHERE status = ''paid''
  WHERE amount > 100

COLUMN ORDER (rules):
  1. Equality (=) columns go FIRST.
  2. Range columns (>, <, BETWEEN) go LAST (after one range column, the
     following columns can no longer be used for seeking).
  3. Add SELECTed columns to the index -> makes it covering.

ORDER BY OPTIMIZATION:
  -- index (user_id, created_at) serves:
  SELECT * FROM orders WHERE user_id=42 ORDER BY created_at DESC;
  -- NO filesort needed because the index is already ordered by created_at.'
WHERE id='n_my_covering';
