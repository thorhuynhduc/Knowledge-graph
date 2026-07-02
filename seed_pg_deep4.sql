-- ĐÀO SÂU PostgreSQL (đợt 1d): Planner, Index types, JSONB
UPDATE kg_nodes SET
description=
'Planner là bộ tối ưu DỰA TRÊN CHI PHÍ: ước lượng cost của nhiều kế
hoạch rồi chọn cái RẺ nhất, dựa vào THỐNG KÊ (pg_statistic, cập nhật
bởi ANALYZE).

VÍ DỤ — vì sao planner BỎ QUA index:

  -- Sau khi nạp 1 triệu dòng nhưng CHƯA analyze:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Seq Scan ... rows=1     (ước lượng SAI vì thống kê cũ)

  ANALYZE orders;            -- cập nhật thống kê
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Index Scan ... rows=5000 (giờ ước lượng đúng -> chọn index)

LÝ DO PLANNER KHÔNG DÙNG INDEX (và cách xử lý):
  1. Bảng nhỏ            -> Seq Scan nhanh hơn (bình thường, kệ nó).
  2. Khớp quá nhiều hàng (> ~5-10% bảng) -> quét tuần tự rẻ hơn.
  3. Thống kê cũ         -> chạy ANALYZE (hoặc chờ autovacuum analyze).
  4. Hàm bọc quanh cột   -> WHERE lower(email)=... -> tạo expression index.
  5. Lệch kiểu dữ liệu   -> WHERE int_col = ''5'' (so string) -> ép đúng kiểu.

CÔNG CỤ:
  • ANALYZE / auto-analyze cập nhật thống kê phân bố dữ liệu.
  • ALTER TABLE t ALTER COLUMN c SET STATISTICS 1000; -- cột lệch phân bố.
  • Luôn EXPLAIN ANALYZE để XÁC NHẬN, đừng đoán theo cảm giác.'
,description_en=
'The planner is a COST-BASED optimizer: it estimates the cost of many
plans and picks the CHEAPEST, based on STATISTICS (pg_statistic,
updated by ANALYZE).

EXAMPLE - why the planner IGNORES an index:

  -- After loading 1 million rows but WITHOUT analyzing:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Seq Scan ... rows=1     (WRONG estimate due to stale stats)

  ANALYZE orders;            -- refresh statistics
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Index Scan ... rows=5000 (now the estimate is right -> uses index)

WHY THE PLANNER DOES NOT USE AN INDEX (and the fix):
  1. Small table         -> Seq Scan is faster (normal, leave it).
  2. Matches too many rows (> ~5-10% of the table) -> seq scan cheaper.
  3. Stale statistics    -> run ANALYZE (or wait for autovacuum analyze).
  4. Function on a column -> WHERE lower(email)=... -> make an expression index.
  5. Type mismatch       -> WHERE int_col = ''5'' (vs string) -> cast correctly.

TOOLS:
  • ANALYZE / auto-analyze refresh data-distribution statistics.
  • ALTER TABLE t ALTER COLUMN c SET STATISTICS 1000; -- for skewed columns.
  • Always EXPLAIN ANALYZE to CONFIRM, do not guess.'
WHERE id='n_pg_planner';

UPDATE kg_nodes SET
description=
'Ngoài B-tree, PostgreSQL có index chuyên biệt cho từng loại dữ liệu:

  GIN  : giá trị chứa NHIỀU phần tử — JSONB, mảng, full-text search.
  GiST : dữ liệu hình học/không gian (PostGIS), phạm vi (range).
  BRIN : bảng RẤT lớn, dữ liệu sắp theo thứ tự tự nhiên (log theo thời
         gian) — index cực nhỏ.
  Hash : chỉ cho so sánh = (ít dùng hơn B-tree).

GIN cho JSONB (tìm theo chứa/khóa):
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

GIN cho MẢNG (tìm phần tử trong mảng):
  CREATE INDEX idx_tags ON posts USING GIN (tags);
  SELECT * FROM posts WHERE tags @> ARRAY[''vip''];

GIN full-text search:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));
  SELECT * FROM docs
   WHERE to_tsvector(''english'', body) @@ plainto_tsquery(''postgres'');

BRIN cho bảng log khổng lồ theo thời gian:
  CREATE INDEX idx_ts ON logs USING BRIN (created_at);
  -- nhỏ hơn B-tree hàng chục lần, tốt khi dữ liệu chèn theo thứ tự thời gian

Chọn ĐÚNG loại index theo DẠNG truy vấn là chìa khóa tối ưu.'
,description_en=
'Besides B-tree, PostgreSQL has index types specialized per data kind:

  GIN  : values containing MANY elements — JSONB, arrays, full-text.
  GiST : geometric/spatial data (PostGIS), ranges.
  BRIN : VERY large tables with naturally ordered data (time-series
         logs) — a tiny index.
  Hash : only for = comparisons (less used than B-tree).

GIN for JSONB (containment/key search):
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

GIN for ARRAYS (find an element in an array):
  CREATE INDEX idx_tags ON posts USING GIN (tags);
  SELECT * FROM posts WHERE tags @> ARRAY[''vip''];

GIN full-text search:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));
  SELECT * FROM docs
   WHERE to_tsvector(''english'', body) @@ plainto_tsquery(''postgres'');

BRIN for a huge time-series log table:
  CREATE INDEX idx_ts ON logs USING BRIN (created_at);
  -- tens of times smaller than B-tree, great when data is inserted in
  -- time order

Choosing the RIGHT index type for the query shape is the key to tuning.'
WHERE id='n_pg_index_types';

UPDATE kg_nodes SET
description=
'JSONB lưu JSON ở dạng nhị phân đã phân giải -> truy vấn nhanh, index
được; khác kiểu json (lưu text nguyên văn, chậm khi truy vấn).

TẠO & CHÈN:
  CREATE TABLE products (id serial PRIMARY KEY, data jsonb);
  INSERT INTO products (data) VALUES
    (''{"name":"Phone","brand":"acme","price":300,"tags":["new"]}'');

TRUY VẤN — các toán tử hay dùng:
  data->''brand''    -> giá trị dạng jsonb   ("acme")
  data->>''brand''   -> giá trị dạng text    (acme)
  data#>>''{a,b}''   -> lấy sâu theo đường dẫn
  data @> ''{...}''  -> CHỨA (containment), dùng được GIN index
  data ? ''brand''   -> khóa có tồn tại không?

  SELECT data->>''name'' AS name
  FROM products
  WHERE data @> ''{"brand":"acme"}''
    AND (data->>''price'')::int > 100;

CẬP NHẬT một field (jsonb_set):
  UPDATE products
     SET data = jsonb_set(data, ''{price}'', ''350'')
   WHERE id = 1;

INDEX cho truy vấn containment:
  CREATE INDEX idx_data ON products USING GIN (data);

KHI NÀO DÙNG: dữ liệu bán cấu trúc/linh hoạt (thuộc tính hay đổi). Vẫn
nên chuẩn hóa thành cột riêng cho những trường hay lọc/nối/khóa ngoại.'
,description_en=
'JSONB stores JSON in a parsed binary form -> fast to query and can be
indexed; unlike the json type (raw text, slow to query).

CREATE & INSERT:
  CREATE TABLE products (id serial PRIMARY KEY, data jsonb);
  INSERT INTO products (data) VALUES
    (''{"name":"Phone","brand":"acme","price":300,"tags":["new"]}'');

QUERY - common operators:
  data->''brand''    -> value as jsonb   ("acme")
  data->>''brand''   -> value as text    (acme)
  data#>>''{a,b}''   -> deep get by path
  data @> ''{...}''  -> CONTAINMENT, can use a GIN index
  data ? ''brand''   -> does the key exist?

  SELECT data->>''name'' AS name
  FROM products
  WHERE data @> ''{"brand":"acme"}''
    AND (data->>''price'')::int > 100;

UPDATE a single field (jsonb_set):
  UPDATE products
     SET data = jsonb_set(data, ''{price}'', ''350'')
   WHERE id = 1;

INDEX for containment queries:
  CREATE INDEX idx_data ON products USING GIN (data);

WHEN TO USE: semi-structured/flexible data (changing attributes).
Still normalize into real columns the fields you often filter/join on.'
WHERE id='n_pg_jsonb';
