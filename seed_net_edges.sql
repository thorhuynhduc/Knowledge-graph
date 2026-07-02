-- TOPIC Network: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_net','root','t_net','part-of'),
('e_t_net_s_model','t_net','s_net_model','part-of'),
('e_t_net_s_app','t_net','s_net_app','part-of'),
('e_t_net_s_infra','t_net','s_net_infra','part-of'),
-- model
('e_s_net_model_model','s_net_model','n_net_model','part-of'),
('e_s_net_model_ip','s_net_model','n_net_ip','part-of'),
('e_s_net_model_tcpudp','s_net_model','n_net_tcp_udp','part-of'),
('e_s_net_model_ports','s_net_model','n_net_ports','part-of'),
-- app
('e_s_net_app_dns','s_net_app','n_net_dns','part-of'),
('e_s_net_app_http','s_net_app','n_net_http','part-of'),
('e_s_net_app_tls','s_net_app','n_net_tls','part-of'),
('e_s_net_app_rest','s_net_app','n_net_rest','part-of'),
-- infra
('e_s_net_infra_natfw','s_net_infra','n_net_nat_fw','part-of'),
('e_s_net_infra_lb','s_net_infra','n_net_lb','part-of'),
('e_s_net_infra_proxy','s_net_infra','n_net_proxy','part-of'),
('e_s_net_infra_cdn','s_net_infra','n_net_cdn','part-of'),
-- related (nội bộ)
('e_net_model_tcpudp','n_net_model','n_net_tcp_udp','related'),
('e_net_tcpudp_ports','n_net_tcp_udp','n_net_ports','related'),
('e_net_http_tls','n_net_http','n_net_tls','related'),
('e_net_http_rest','n_net_http','n_net_rest','related'),
('e_net_dns_cdn','n_net_dns','n_net_cdn','related'),
('e_net_lb_proxy','n_net_lb','n_net_proxy','related'),
('e_net_natfw_ports','n_net_nat_fw','n_net_ports','related'),
-- related (liên topic)
('e_net_lb_ms_gateway','n_net_lb','n_ms_gateway','related'),
('e_net_proxy_docker','n_net_proxy','t_docker','related'),
('e_net_rest_ms','n_net_rest','n_ms_sync','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
