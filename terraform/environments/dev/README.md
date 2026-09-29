# Dev Environment

This environment provisions the AWS foundation and a self-managed EKS worker-node layer.

## Flow

VPC -> IAM/ECR -> EKS control plane -> EC2 worker-node ASG

## Commands

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform show tfplan
```

Do not run `terraform apply` until the plan has been reviewed.
