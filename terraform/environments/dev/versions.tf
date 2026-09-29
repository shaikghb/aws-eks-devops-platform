terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Enable this after creating the Terraform state bucket.
  # backend "s3" {
  #   bucket       = "REPLACE_WITH_TERRAFORM_STATE_BUCKET"
  #   key          = "aws-eks-devops-platform/dev/terraform.tfstate"
  #   region       = "ap-southeast-2"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}
