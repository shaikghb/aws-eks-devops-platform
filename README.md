# AWS EKS DevOps Platform 🚀

A production-style DevOps project that demonstrates how to containerize applications, provision AWS infrastructure using Terraform, deploy applications to Amazon EKS with Kubernetes, expose them through an AWS Application Load Balancer, and automate deployment using GitHub Actions with AWS OIDC authentication.

---

## 📌 Project Overview

This project implements an end-to-end DevOps workflow:

```text
Developer
   │
   │ git push
   ▼
GitHub
   │
   ▼
GitHub Actions
   │
   ├── Build Docker Images
   ├── Authenticate to AWS using OIDC
   ├── Push Images to Amazon ECR
   └── Deploy to Amazon EKS
   │
   ▼
Kubernetes
   │
   ├── Frontend
   └── Backend
   │
   ▼
AWS Load Balancer Controller
   │
   ▼
Application Load Balancer
   │
   ▼
Internet