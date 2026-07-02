-- TOPIC Docker: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_docker','root','t_docker','part-of'),
('e_t_docker_s_core','t_docker','s_dk_core','part-of'),
('e_t_docker_s_run','t_docker','s_dk_run','part-of'),
('e_t_docker_s_ops','t_docker','s_dk_ops','part-of'),
-- core
('e_s_dk_core_concept','s_dk_core','n_dk_concept','part-of'),
('e_s_dk_core_dockerfile','s_dk_core','n_dk_dockerfile','part-of'),
('e_s_dk_core_layers','s_dk_core','n_dk_layers','part-of'),
('e_s_dk_core_registry','s_dk_core','n_dk_registry','part-of'),
-- run
('e_s_dk_run_volumes','s_dk_run','n_dk_volumes','part-of'),
('e_s_dk_run_networks','s_dk_run','n_dk_networks','part-of'),
('e_s_dk_run_ports_env','s_dk_run','n_dk_ports_env','part-of'),
('e_s_dk_run_compose','s_dk_run','n_dk_compose','part-of'),
-- ops
('e_s_dk_ops_multistage','s_dk_ops','n_dk_multistage','part-of'),
('e_s_dk_ops_bestpractice','s_dk_ops','n_dk_bestpractice','part-of'),
('e_s_dk_ops_ops','s_dk_ops','n_dk_ops','part-of'),
-- related
('e_dk_dockerfile_layers','n_dk_dockerfile','n_dk_layers','related'),
('e_dk_layers_multistage','n_dk_layers','n_dk_multistage','related'),
('e_dk_multistage_bestpractice','n_dk_multistage','n_dk_bestpractice','related'),
('e_dk_compose_networks','n_dk_compose','n_dk_networks','related'),
('e_dk_compose_volumes','n_dk_compose','n_dk_volumes','related'),
('e_dk_dockerfile_registry','n_dk_dockerfile','n_dk_registry','related'),
('e_t_docker_t_ms','t_docker','t_ms','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
