-- ĐÀO SÂU PostgreSQL (đợt 1c): WAL, VACUUM, B-tree
UPDATE kg_nodes SET
description=
'WAL (Write-Ahead Log): mọi thay đổi được ghi vào một log TUẦN TỰ
TRƯỚC khi ghi vào data file. Đây là nền của durability + crash recovery.

SƠ ĐỒ luồng ghi khi COMMIT:
  UPDATE ...
    │
    ▼
  1. sửa trang trong shared_buffers (RAM)          [nhanh]
  2. ghi bản ghi WAL -> WAL buffer -> đĩa,
     + fsync khi COMMIT                            [ĐIỂM BỀN VỮNG]
  3. trả OK cho client
  ... sau đó (không đồng bộ với client):
  4. checkpoint: flush các trang "bẩn" xuống data file

VÌ SAO NHANH MÀ VẪN AN TOÀN:
  • WAL ghi TUẦN TỰ (append) -> nhanh hơn ghi ngẫu nhiên vào data file.
  • Chỉ cần WAL đã fsync là COMMIT an toàn; data file cập nhật sau.
  • Mất điện -> khởi động lại sẽ REPLAY WAL từ checkpoint gần nhất để
    khôi phục mọi thay đổi đã commit.

WAL CÒN DÙNG CHO:
  • Streaming replication (replica đọc WAL của primary).
  • PITR (Point-In-Time Recovery): backup nền + WAL -> khôi phục về
    đúng một thời điểm.

CẤU HÌNH:
  fsync = on              -- KHÔNG tắt ở production (tắt = mất an toàn)
  wal_level = replica     -- đủ cho replication
  synchronous_commit = on -- on (an toàn) / off (nhanh, có thể mất vài
                          --   giao dịch cuối nếu crash)'
,description_en=
'WAL (Write-Ahead Log): every change is written SEQUENTIALLY to a log
BEFORE being written to data files. This is the basis of durability +
crash recovery.

WRITE FLOW ON COMMIT:
  UPDATE ...
    │
    ▼
  1. modify the page in shared_buffers (RAM)        [fast]
  2. write the WAL record -> WAL buffer -> disk,
     + fsync on COMMIT                              [DURABILITY POINT]
  3. return OK to the client
  ... later (not in sync with the client):
  4. checkpoint: flush "dirty" pages to the data files

WHY IT IS FAST YET SAFE:
  • WAL is written SEQUENTIALLY (append) -> faster than random writes
    into data files.
  • Once WAL is fsynced the COMMIT is safe; data files update later.
  • On power loss -> on restart it REPLAYS WAL from the last checkpoint
    to recover all committed changes.

WAL IS ALSO USED FOR:
  • Streaming replication (a replica reads the primary WAL).
  • PITR (Point-In-Time Recovery): base backup + WAL -> restore to an
    exact moment.

CONFIG:
  fsync = on              -- do NOT turn off in production (unsafe)
  wal_level = replica     -- enough for replication
  synchronous_commit = on -- on (safe) / off (fast, may lose the last
                          --   few transactions on a crash)'
WHERE id='n_pg_wal';

UPDATE kg_nodes SET
description=
'MVCC để lại tuple CHẾT (dead) sau mỗi UPDATE/DELETE. VACUUM dọn chúng
để tái dùng không gian; autovacuum chạy tự động ở nền.

XEM tình trạng dead tuple + lần vacuum gần nhất:
  SELECT relname, n_live_tup, n_dead_tup, last_autovacuum
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC;

CÁC LỆNH:
  VACUUM my_table;            -- đánh dấu không gian tuple chết là tái
                              --   dùng được (KHÔNG trả về OS), cập nhật FSM
  VACUUM (ANALYZE) my_table;  -- vacuum + cập nhật thống kê cho planner
  VACUUM FULL my_table;       -- nén bảng, TRẢ không gian cho OS, nhưng
                              --   KHÓA bảng độc quyền (tránh giờ cao điểm)
  ANALYZE my_table;           -- chỉ cập nhật thống kê

GIẢI THÍCH:
  • VACUUM thường : nhanh, không khóa nặng, đủ cho vận hành hàng ngày.
  • VACUUM FULL   : viết lại TOÀN BỘ bảng -> giành lại đĩa nhưng CHẶN
    đọc/ghi -> chỉ dùng khi bloat nặng, trong cửa sổ bảo trì.

DẤU HIỆU CẦN CHÚ Ý:
  • n_dead_tup lớn / bảng phình dần -> autovacuum không theo kịp; chỉnh
    autovacuum_vacuum_scale_factor thấp hơn cho bảng ghi nhiều.
  • Transaction ID wraparound (nguy hiểm) -> PG buộc vacuum khẩn cấp;
    đừng để transaction dài hoặc replication slot treo giữ tuple chết.'
,description_en=
'MVCC leaves DEAD tuples behind after each UPDATE/DELETE. VACUUM cleans
them so the space can be reused; autovacuum runs automatically in the
background.

CHECK dead-tuple status + last vacuum:
  SELECT relname, n_live_tup, n_dead_tup, last_autovacuum
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC;

COMMANDS:
  VACUUM my_table;            -- mark dead-tuple space reusable (does
                              --   NOT return to OS), update the FSM
  VACUUM (ANALYZE) my_table;  -- vacuum + refresh planner statistics
  VACUUM FULL my_table;       -- compact the table, RETURN space to the
                              --   OS, but EXCLUSIVELY locks it (off-peak)
  ANALYZE my_table;           -- only refresh statistics

EXPLANATION:
  • Plain VACUUM : fast, no heavy lock, enough for daily operations.
  • VACUUM FULL  : rewrites the WHOLE table -> reclaims disk but BLOCKS
    reads/writes -> use only for heavy bloat, in a maintenance window.

WARNING SIGNS:
  • Large n_dead_tup / a steadily growing table -> autovacuum cannot
    keep up; lower autovacuum_vacuum_scale_factor for write-heavy tables.
  • Transaction ID wraparound (dangerous) -> PG forces an emergency
    vacuum; do not let long transactions or replication slots pin dead
    tuples.'
WHERE id='n_pg_vacuum';

UPDATE kg_nodes SET
description=
'B-tree là index mặc định: hợp cho =, <, >, BETWEEN, ORDER BY và
LIKE ''abc%'' (tiền tố).

SƠ ĐỒ (cây cân bằng, lá liên kết đôi):
        [ 50 | 100 ]
         /     |     \
   [..30] [50..80] [100..]
      │       │        │
    lá ↔    lá ↔      lá ↔    -> quét range nhanh nhờ lá nối nhau

TẠO & DÙNG:
  CREATE INDEX idx_u_email ON users (email);
  -- phục vụ: WHERE email = ... ; ORDER BY email ; email LIKE ''a%''

INDEX NHIỀU CỘT (thứ tự cột QUAN TRỌNG — leftmost prefix):
  CREATE INDEX idx_o ON orders (user_id, created_at);
  -- ✓ WHERE user_id = 42
  -- ✓ WHERE user_id = 42 AND created_at > ''2026-01-01''
  -- ✗ WHERE created_at > ...    (bỏ cột đầu -> index kém tác dụng)

PARTIAL INDEX (chỉ index phần cần -> nhỏ & nhanh):
  CREATE INDEX idx_active ON users (email) WHERE active = true;

EXPRESSION INDEX (khi query bọc hàm quanh cột):
  -- WHERE lower(email) = ... sẽ KHÔNG dùng index thường
  CREATE INDEX idx_lower_email ON users (lower(email));

Kiểm chứng: EXPLAIN thấy "Index Scan" / "Index Cond" -> index có tác dụng.'
,description_en=
'B-tree is the default index: good for =, <, >, BETWEEN, ORDER BY, and
LIKE ''abc%'' (prefix).

DIAGRAM (balanced tree, doubly-linked leaves):
        [ 50 | 100 ]
         /     |     \
   [..30] [50..80] [100..]
      │       │        │
    leaf ↔  leaf ↔   leaf ↔   -> fast range scans via linked leaves

CREATE & USE:
  CREATE INDEX idx_u_email ON users (email);
  -- serves: WHERE email = ... ; ORDER BY email ; email LIKE ''a%''

MULTI-COLUMN INDEX (column order MATTERS - leftmost prefix):
  CREATE INDEX idx_o ON orders (user_id, created_at);
  -- OK  WHERE user_id = 42
  -- OK  WHERE user_id = 42 AND created_at > ''2026-01-01''
  -- NO  WHERE created_at > ...    (skips the first column -> weak)

PARTIAL INDEX (index only what you need -> small & fast):
  CREATE INDEX idx_active ON users (email) WHERE active = true;

EXPRESSION INDEX (when a query wraps a function around a column):
  -- WHERE lower(email) = ... will NOT use a plain index
  CREATE INDEX idx_lower_email ON users (lower(email));

Verify: EXPLAIN showing "Index Scan" / "Index Cond" -> the index works.'
WHERE id='n_pg_btree';
