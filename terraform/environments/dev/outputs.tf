output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.security_groups.node_security_group_id
}

output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_repository_url" {
  value = module.ecr.backend_repository_url
}

output "node_role_arn" {
  value = module.iam.eks_node_role_arn
}

output "node_autoscaling_group_name" {
  value = module.nodes.autoscaling_group_name
}

output "node_launch_template_id" {
  value = module.nodes.launch_template_id
}
