# Terraform Infrastructure

Modular Terraform for the `aws-eks-devops-platform` project.

## Current modules

- `vpc`: VPC, public/private subnets, NAT gateways and route tables
- `security-groups`: worker-node security group
- `iam`: EKS cluster and self-managed worker-node IAM roles
- `ecr`: frontend and backend ECR repositories with scanning/lifecycle policies
- `eks`: EKS control plane and core add-ons
- `nodes`: self-managed EC2 worker node launch template and Auto Scaling Group
- `cloudwatch`: EKS log group

## Important

The S3 backend block in `environments/dev/versions.tf` is intentionally commented until the bootstrap state bucket exists. The node module is provided separately because worker-node bootstrap should be validated after the EKS control plane is created.
