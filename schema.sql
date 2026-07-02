-- ===================================================================
--  KNOWLEDGE GRAPH — MySQL schema (mysqli)
--  Chạy file này trong phpMyAdmin / MySQL CLI, HOẶC bấm nút
--  "Init DB" trên giao diện (gọi api.php?action=setup).
-- ===================================================================

-- Bảng lưu các node (khái niệm kiến thức)
CREATE TABLE IF NOT EXISTS kg_nodes (
  id          VARCHAR(64)  NOT NULL PRIMARY KEY,
  label       VARCHAR(255) NOT NULL,
  category    VARCHAR(64)  NOT NULL DEFAULT 'Frontend',
  description TEXT         NULL,
  description_en TEXT      NULL,                 -- bản dịch tiếng Anh (toggle VI/EN)
  links       TEXT         NULL,                 -- mảng JSON các link học tập
  pos_x       DOUBLE       NULL,                 -- vị trí node trên graph
  pos_y       DOUBLE       NULL,
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng lưu các quan hệ (edge) giữa các node
CREATE TABLE IF NOT EXISTS kg_edges (
  id         VARCHAR(64) NOT NULL PRIMARY KEY,
  source     VARCHAR(64) NOT NULL,
  target     VARCHAR(64) NOT NULL,
  type       VARCHAR(32) NOT NULL DEFAULT 'related',
  created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_src (source),
  INDEX idx_tgt (target),
  -- Xóa node sẽ tự động xóa các quan hệ liên quan
  CONSTRAINT fk_src FOREIGN KEY (source) REFERENCES kg_nodes(id) ON DELETE CASCADE,
  CONSTRAINT fk_tgt FOREIGN KEY (target) REFERENCES kg_nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
