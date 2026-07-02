-- TOPIC PHP: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_php','root','t_php','part-of'),
('e_t_php_s_basics','t_php','s_php_basics','part-of'),
('e_t_php_s_oop','t_php','s_php_oop','part-of'),
('e_t_php_s_web','t_php','s_php_web','part-of'),
('e_t_php_s_modern','t_php','s_php_modern','part-of'),
-- basics
('e_s_php_basics_syntax','s_php_basics','n_php_syntax','part-of'),
('e_s_php_basics_types','s_php_basics','n_php_types','part-of'),
('e_s_php_basics_arrays','s_php_basics','n_php_arrays','part-of'),
('e_s_php_basics_functions','s_php_basics','n_php_functions','part-of'),
-- oop
('e_s_php_oop_oop','s_php_oop','n_php_oop','part-of'),
('e_s_php_oop_traits','s_php_oop','n_php_traits','part-of'),
('e_s_php_oop_namespaces','s_php_oop','n_php_namespaces','part-of'),
-- web
('e_s_php_web_request','s_php_web','n_php_request','part-of'),
('e_s_php_web_superglobals','s_php_web','n_php_superglobals','part-of'),
('e_s_php_web_pdo','s_php_web','n_php_pdo','part-of'),
('e_s_php_web_security','s_php_web','n_php_security','part-of'),
-- modern
('e_s_php_modern_php8','s_php_modern','n_php_php8','part-of'),
('e_s_php_modern_psr','s_php_modern','n_php_psr','part-of'),
('e_s_php_modern_frameworks','s_php_modern','n_php_frameworks','part-of'),
-- related
('e_php_pdo_security','n_php_pdo','n_php_security','related'),
('e_php_pdo_frameworks','n_php_pdo','n_php_frameworks','related'),
('e_php_namespaces_psr','n_php_namespaces','n_php_psr','related'),
('e_php_request_frameworks','n_php_request','n_php_frameworks','related'),
('e_php_oop_traits','n_php_oop','n_php_traits','related'),
('e_php_superglobals_security','n_php_superglobals','n_php_security','related'),
('e_php_pdo_t_mysql','n_php_pdo','t_mysql','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
