variable "project_name" { type = string }
variable "environment" { type = string }
variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "node_security_group_id" { type = string }
variable "node_instance_profile_name" { type = string }
variable "node_instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate_authority" {
  type = string
}

variable "cluster_service_cidr" {
  type = string
}