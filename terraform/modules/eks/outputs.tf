output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_service_cidr" {
  value = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster.id
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}