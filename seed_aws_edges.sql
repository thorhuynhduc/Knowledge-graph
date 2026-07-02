-- TOPIC AWS: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_aws','root','t_aws','part-of'),
('e_t_aws_s_core','t_aws','s_aws_core','part-of'),
('e_t_aws_s_compute','t_aws','s_aws_compute','part-of'),
('e_t_aws_s_data','t_aws','s_aws_data','part-of'),
('e_t_aws_s_ops','t_aws','s_aws_ops','part-of'),
-- core
('e_s_aws_core_global','s_aws_core','n_aws_global','part-of'),
('e_s_aws_core_iam','s_aws_core','n_aws_iam','part-of'),
('e_s_aws_core_vpc','s_aws_core','n_aws_vpc','part-of'),
-- compute
('e_s_aws_compute_ec2','s_aws_compute','n_aws_ec2','part-of'),
('e_s_aws_compute_lambda','s_aws_compute','n_aws_lambda','part-of'),
('e_s_aws_compute_containers','s_aws_compute','n_aws_containers','part-of'),
('e_s_aws_compute_scaling','s_aws_compute','n_aws_scaling','part-of'),
-- data
('e_s_aws_data_s3','s_aws_data','n_aws_s3','part-of'),
('e_s_aws_data_rds','s_aws_data','n_aws_rds','part-of'),
('e_s_aws_data_dynamodb','s_aws_data','n_aws_dynamodb','part-of'),
('e_s_aws_data_cache','s_aws_data','n_aws_cache','part-of'),
-- ops
('e_s_aws_ops_cloudfront','s_aws_ops','n_aws_cloudfront','part-of'),
('e_s_aws_ops_route53','s_aws_ops','n_aws_route53','part-of'),
('e_s_aws_ops_cloudwatch','s_aws_ops','n_aws_cloudwatch','part-of'),
('e_s_aws_ops_messaging','s_aws_ops','n_aws_messaging','part-of'),
-- related (nội bộ AWS)
('e_aws_ec2_scaling','n_aws_ec2','n_aws_scaling','related'),
('e_aws_ec2_containers','n_aws_ec2','n_aws_containers','related'),
('e_aws_lambda_dynamodb','n_aws_lambda','n_aws_dynamodb','related'),
('e_aws_s3_cloudfront','n_aws_s3','n_aws_cloudfront','related'),
('e_aws_rds_dynamodb','n_aws_rds','n_aws_dynamodb','related'),
('e_aws_vpc_scaling','n_aws_vpc','n_aws_scaling','related'),
('e_aws_cloudwatch_scaling','n_aws_cloudwatch','n_aws_scaling','related'),
('e_aws_route53_cloudfront','n_aws_route53','n_aws_cloudfront','related'),
('e_aws_iam_ec2','n_aws_iam','n_aws_ec2','related'),
-- related (liên topic)
('e_aws_containers_docker','n_aws_containers','t_docker','related'),
('e_aws_cloudfront_cdn','n_aws_cloudfront','n_net_cdn','related'),
('e_aws_route53_dns','n_aws_route53','n_net_dns','related'),
('e_aws_vpc_natfw','n_aws_vpc','n_net_nat_fw','related'),
('e_aws_scaling_lb','n_aws_scaling','n_net_lb','related'),
('e_aws_rds_mysql','n_aws_rds','t_mysql','related'),
('e_aws_messaging_ms','n_aws_messaging','n_ms_async','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
