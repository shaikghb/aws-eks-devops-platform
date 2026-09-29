variable "aws_region" {
  description = "AWS region for the environment."
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
  default     = "aws-eks-devops-platform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC."
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "cluster_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.33"
}

variable "node_instance_type" {
  description = "EC2 instance type for self-managed EKS worker nodes."
  type        = string
  default     = "t3.small"
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 3
}

variable "frontend_repository_name" {
  description = "ECR repository name for the React frontend."
  type        = string
  default     = "aws-eks-devops-frontend"
}

variable "backend_repository_name" {
  description = "ECR repository name for the Node.js backend."
  type        = string
  default     = "aws-eks-devops-backend"
}
