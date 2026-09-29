module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}
data "aws_eks_cluster" "existing" {
  name = "${var.project_name}-${var.environment}-eks"
}

module "iam" {
  source = "../../modules/iam"

  project_name    = var.project_name
  environment     = var.environment
  cluster_name    = "${var.project_name}-${var.environment}-eks"
  oidc_issuer_url = data.aws_eks_cluster.existing.identity[0].oidc[0].issuer
}

module "ecr" {
  source = "../../modules/ecr"

  project_name             = var.project_name
  environment              = var.environment
  frontend_repository_name = var.frontend_repository_name
  backend_repository_name  = var.backend_repository_name
}

module "eks" {
  source = "../../modules/eks"

  project_name           = var.project_name
  environment            = var.environment
  cluster_name           = "${var.project_name}-${var.environment}-eks"
  cluster_version        = var.cluster_version
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  cluster_role_arn       = module.iam.eks_cluster_role_arn
  node_role_arn          = module.iam.eks_node_role_arn
  node_security_group_id = module.security_groups.node_security_group_id

  depends_on = [module.iam, module.security_groups]
}

module "nodes" {
  source = "../../modules/nodes"

  project_name                  = var.project_name
  environment                   = var.environment
  cluster_name                  = module.eks.cluster_name
  cluster_version               = var.cluster_version
  cluster_endpoint              = module.eks.cluster_endpoint
  cluster_certificate_authority = module.eks.cluster_certificate_authority_data
  cluster_service_cidr          = module.eks.cluster_service_cidr
  private_subnet_ids            = module.vpc.private_subnet_ids
  node_security_group_id        = module.security_groups.node_security_group_id
  node_instance_profile_name    = module.iam.eks_node_instance_profile_name
  node_instance_type            = var.node_instance_type
  desired_capacity              = var.node_desired_capacity
  min_size                      = var.node_min_size
  max_size                      = var.node_max_size

  depends_on = [module.eks]
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  cluster_name = module.eks.cluster_name
}
resource "aws_vpc_security_group_ingress_rule" "control_plane_to_nodes" {
  security_group_id            = module.security_groups.node_security_group_id
  referenced_security_group_id = module.eks.cluster_security_group_id
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_to_webhook" {
  security_group_id            = module.security_groups.node_security_group_id
  referenced_security_group_id = module.eks.cluster_security_group_id
  from_port                    = 9443
  to_port                      = 9443
  ip_protocol                  = "tcp"
}

