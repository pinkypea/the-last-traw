# Output the cluster details
output "eks_cluster_name" {
  value = aws_eks_cluster.the-last-straw-cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.the-last-straw-cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.the-last-straw-cluster.certificate_authority[0].data
}

output "node_group_name" {
  value = aws_eks_node_group.the-last-straw-node-group.node_group_name
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.the-last-straw-vpc.id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.the-last-straw-vpc.cidr_block
}
output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.the-last-straw-vpc.default_route_table_id
}
output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}