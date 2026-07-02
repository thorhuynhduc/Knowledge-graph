-- ĐÀO SÂU PostgreSQL (đợt 1e): CTE/Window, Types, Partitioning
UPDATE kg_nodes SET
description=
'CTE (WITH) đặt tên cho truy vấn con -> dễ đọc, chia nhỏ query lớn; hỗ
trợ đệ quy. Window function tính TRÊN một khung hàng mà KHÔNG gộp nhóm
(giữ nguyên từng dòng).

CTE (chia nhiều bước rõ ràng):
  WITH recent AS (
    SELECT * FROM orders
    WHERE created_at > now() - interval ''7 days''
  ),
  by_user AS (
    SELECT user_id, count(*) AS n FROM recent GROUP BY user_id
  )
  SELECT * FROM by_user WHERE n > 5;

WINDOW FUNCTION (thêm cột tính toán, GIỮ từng hàng):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk,
         avg(salary) OVER (PARTITION BY dept)                      AS dept_avg
  FROM employees;

  -- Kết quả mẫu:
  --  name  dept  salary  rnk  dept_avg
  --  An    IT     1200    1     1000
  --  Binh  IT      800    2     1000

GIẢI THÍCH:
  • PARTITION BY dept    : chia nhóm theo phòng (như GROUP BY nhưng
    KHÔNG gộp dòng lại).
  • ORDER BY salary DESC : thứ tự trong nhóm để rank() đánh số.
  • Hàm khác: row_number(), dense_rank(), lag()/lead() (dòng trước/sau),
    sum() OVER (...) để cộng dồn.

CTE ĐỆ QUY (duyệt cây/đồ thị — vd cây danh mục):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id, name FROM cat WHERE id = 1        -- gốc
    UNION ALL
    SELECT c.id, c.parent_id, c.name
    FROM cat c JOIN tree t ON c.parent_id = t.id            -- bước đệ quy
  )
  SELECT * FROM tree;'
,description_en=
'A CTE (WITH) names a subquery -> readable, splits a big query; supports
recursion. A window function computes OVER a frame of rows WITHOUT
collapsing groups (keeps each row).

CTE (clear multi-step):
  WITH recent AS (
    SELECT * FROM orders
    WHERE created_at > now() - interval ''7 days''
  ),
  by_user AS (
    SELECT user_id, count(*) AS n FROM recent GROUP BY user_id
  )
  SELECT * FROM by_user WHERE n > 5;

WINDOW FUNCTION (add computed columns, KEEP each row):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk,
         avg(salary) OVER (PARTITION BY dept)                      AS dept_avg
  FROM employees;

  -- Sample result:
  --  name  dept  salary  rnk  dept_avg
  --  An    IT     1200    1     1000
  --  Binh  IT      800    2     1000

EXPLANATION:
  • PARTITION BY dept    : group by department (like GROUP BY but does
    NOT collapse rows).
  • ORDER BY salary DESC : order within the group so rank() numbers them.
  • Others: row_number(), dense_rank(), lag()/lead() (prev/next row),
    sum() OVER (...) for a running total.

RECURSIVE CTE (walk a tree/graph - e.g. a category tree):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id, name FROM cat WHERE id = 1        -- root
    UNION ALL
    SELECT c.id, c.parent_id, c.name
    FROM cat c JOIN tree t ON c.parent_id = t.id            -- recursive step
  )
  SELECT * FROM tree;'
WHERE id='n_pg_cte_window';

UPDATE kg_nodes SET
description=
'PostgreSQL nổi bật vì hệ KIỂU giàu, giảm xử lý ở tầng app:

  uuid     : khóa phân tán    -> gen_random_uuid()
  array    : mảng             -> int[] , text[]
  enum     : tập giá trị cố định
  range    : khoảng           -> int4range, tstzrange
  jsonb    : tài liệu linh hoạt
  inet     : địa chỉ IP/mạng
  tsvector : full-text search

VÍ DỤ MẢNG:
  CREATE TABLE ev (id serial, tags text[]);
  INSERT INTO ev (tags) VALUES (ARRAY[''vip'',''sale'']);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);      -- có phần tử vip?
  SELECT * FROM ev WHERE tags @> ARRAY[''vip''];   -- chứa (dùng GIN index)

VÍ DỤ ENUM:
  CREATE TYPE mood AS ENUM (''low'',''ok'',''high'');
  CREATE TABLE t (m mood);

VÍ DỤ RANGE + ràng buộc loại trừ (chặn đặt phòng trùng giờ):
  CREATE TABLE booking (
    room   int,
    during tstzrange,
    EXCLUDE USING gist (room WITH =, during WITH &&)
  );
  -- && = giao nhau: 2 booking CÙNG phòng mà giao giờ -> bị CHẶN ngay ở DB

Dùng ĐÚNG kiểu giúp ràng buộc dữ liệu chặt và query gọn hơn.'
,description_en=
'PostgreSQL stands out for its rich TYPE system, reducing app-side work:

  uuid     : distributed keys -> gen_random_uuid()
  array    : arrays           -> int[] , text[]
  enum     : a fixed set of values
  range    : ranges           -> int4range, tstzrange
  jsonb    : flexible documents
  inet     : IP/network addresses
  tsvector : full-text search

ARRAY EXAMPLE:
  CREATE TABLE ev (id serial, tags text[]);
  INSERT INTO ev (tags) VALUES (ARRAY[''vip'',''sale'']);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);      -- has element vip?
  SELECT * FROM ev WHERE tags @> ARRAY[''vip''];   -- contains (uses GIN)

ENUM EXAMPLE:
  CREATE TYPE mood AS ENUM (''low'',''ok'',''high'');
  CREATE TABLE t (m mood);

RANGE + EXCLUSION constraint (prevent overlapping bookings):
  CREATE TABLE booking (
    room   int,
    during tstzrange,
    EXCLUDE USING gist (room WITH =, during WITH &&)
  );
  -- && = overlap: two bookings for the SAME room with overlapping time
  -- are BLOCKED right in the DB

Using the RIGHT type enforces data constraints tightly and keeps
queries cleaner.'
WHERE id='n_pg_types';

UPDATE kg_nodes SET
description=
'Partitioning chia một bảng lớn thành nhiều bảng con theo khóa -> query
chỉ quét phần liên quan (partition pruning) và bảo trì dễ (xóa cả
partition cũ thay vì DELETE hàng loạt).

KIỂU: RANGE (theo khoảng), LIST (theo danh sách), HASH (chia đều).

VÍ DỤ RANGE theo thời gian:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);

  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');
  CREATE TABLE logs_2026_02 PARTITION OF logs
    FOR VALUES FROM (''2026-02-01'') TO (''2026-03-01'');

PARTITION PRUNING (planner tự loại partition không khớp):
  EXPLAIN SELECT * FROM logs WHERE ts >= ''2026-02-10'';
  -- chỉ quét logs_2026_02, BỎ QUA logs_2026_01 -> nhanh hơn nhiều

BẢO TRÌ dễ:
  DROP TABLE logs_2026_01;   -- xóa dữ liệu tháng cũ TỨC THÌ (không DELETE)

KẾT HỢP: dùng BRIN index trên cột thời gian trong mỗi partition. Chỉ
nên partition khi bảng THỰC SỰ lớn (hàng chục triệu dòng trở lên).'
,description_en=
'Partitioning splits a large table into child tables by a key -> queries
scan only the relevant part (partition pruning) and maintenance is easy
(drop a whole old partition instead of a mass DELETE).

KINDS: RANGE (by range), LIST (by a list), HASH (even split).

RANGE-BY-TIME EXAMPLE:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);

  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');
  CREATE TABLE logs_2026_02 PARTITION OF logs
    FOR VALUES FROM (''2026-02-01'') TO (''2026-03-01'');

PARTITION PRUNING (the planner drops non-matching partitions):
  EXPLAIN SELECT * FROM logs WHERE ts >= ''2026-02-10'';
  -- scans only logs_2026_02, SKIPS logs_2026_01 -> much faster

EASY MAINTENANCE:
  DROP TABLE logs_2026_01;   -- delete an old month INSTANTLY (no DELETE)

COMBINE: use a BRIN index on the time column in each partition. Only
partition when the table is TRULY large (tens of millions of rows or more).'
WHERE id='n_pg_partition';
