# 🚀 AWS EKS DevOps Platform

> **End-to-end DevOps platform using Terraform, Docker, Kubernetes, Amazon EKS, Amazon ECR, AWS Application Load Balancer, GitHub Actions, and GitHub OIDC.**

**Author:** Shaik Abzal Sharif  
**Role:** DevOps Engineer

---

## 📌 Project Overview

The **AWS EKS DevOps Platform** is an end-to-end DevOps project that demonstrates how to provision cloud infrastructure, containerize applications, deploy them on Kubernetes, expose them through an AWS Application Load Balancer, and automate the complete deployment process using GitHub Actions.

The project follows this DevOps lifecycle:

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Authenticate with AWS using OIDC
    ├── Build Docker Images
    ├── Push Images to Amazon ECR
    └── Deploy to Amazon EKS
    │
    ▼
Amazon EKS
    │
    ├── Frontend Pods
    └── Backend Pods
    │
    ▼
AWS Load Balancer Controller
    │
    ▼
Application Load Balancer
    │
    ▼
Internet
```

---

# 🏗️ Architecture

```text
                         ┌──────────────────────┐
                         │      Developer       │
                         └──────────┬───────────┘
                                    │
                                git push
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │       GitHub         │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   GitHub Actions     │
                         │                      │
                         │ • Checkout           │
                         │ • OIDC Authentication│
                         │ • Docker Build        │
                         │ • ECR Push            │
                         │ • EKS Deployment      │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │         AWS          │
                         │                      │
                         │        Amazon EKS    │
                         │                      │
                         │  ┌────────────────┐  │
                         │  │ Worker Node 1  │  │
                         │  │                │  │
                         │  │ Frontend Pods  │  │
                         │  │ Backend Pods   │  │
                         │  └────────────────┘  │
                         │                      │
                         │  ┌────────────────┐  │
                         │  │ Worker Node 2  │  │
                         │  │                │  │
                         │  │ Frontend Pods  │  │
                         │  │ Backend Pods   │  │
                         │  └────────────────┘  │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │ AWS Load Balancer    │
                         │ Controller           │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │ Application Load     │
                         │ Balancer             │
                         └──────────┬───────────┘
                                    │
                                    ▼
                                Internet
```

---

# 🎯 Project Objectives

The main objectives of this project are:

- Provision AWS infrastructure using **Terraform**
- Create and configure an **Amazon EKS cluster**
- Use **self-managed EC2 worker nodes**
- Containerize applications using **Docker**
- Store Docker images in **Amazon ECR**
- Deploy applications using **Kubernetes**
- Expose the frontend using an **AWS Application Load Balancer**
- Configure the **AWS Load Balancer Controller**
- Implement CI/CD using **GitHub Actions**
- Use **GitHub OIDC** for secure AWS authentication
- Automate Docker image building and deployment
- Implement Kubernetes rolling updates
- Verify application health
- Clean up AWS resources using Terraform

---

# 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **AWS** | Cloud infrastructure |
| **Amazon EKS** | Kubernetes cluster |
| **Amazon EC2** | Self-managed worker nodes |
| **Amazon ECR** | Docker image registry |
| **Amazon VPC** | Cloud networking |
| **IAM** | Access management |
| **Terraform** | Infrastructure as Code |
| **Docker** | Application containerization |
| **Kubernetes** | Container orchestration |
| **AWS Load Balancer Controller** | Kubernetes-to-ALB integration |
| **Application Load Balancer** | External application access |
| **GitHub Actions** | CI/CD |
| **GitHub OIDC** | Secure AWS authentication |
| **React + Vite** | Frontend |
| **Node.js + Express** | Backend |
| **Nginx** | Frontend production server |
| **Git + GitHub** | Version control |

---

# 📁 Project Structure

```text
aws-eks-devops-platform/
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── app/
│   ├── backend/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   └── server.js
│   │
│   ├── database/
│   │
│   └── frontend/
│       ├── Dockerfile
│       ├── nginx.conf
│       ├── package.json
│       ├── package-lock.json
│       └── src/
│
├── kubernetes/
│   ├── backend/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   │
│   ├── database/
│   │
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   │
│   └── ingress/
│       └── alb.yaml
│
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   └── prod/
│   │
│   ├── modules/
│   │   ├── cloudwatch/
│   │   ├── ecr/
│   │   ├── eks/
│   │   ├── iam/
│   │   ├── nodes/
│   │   ├── security-groups/
│   │   └── vpc/
│   │
│   └── README.md
│
├── docs/
├── scripts/
├── .gitignore
└── README.md
```

---

# ☁️ AWS Infrastructure

Terraform was used to provision and manage the AWS infrastructure.

The infrastructure included:

- Amazon VPC
- Public subnets
- Private subnets
- Internet Gateway
- Route tables
- Security groups
- Amazon EKS cluster
- Self-managed EC2 worker nodes
- IAM roles
- Amazon ECR repositories
- CloudWatch logging
- EKS OIDC provider

The infrastructure was organized into reusable Terraform modules.

```text
Terraform
    │
    ├── VPC Module
    ├── EKS Module
    ├── Nodes Module
    ├── IAM Module
    ├── ECR Module
    ├── Security Groups Module
    └── CloudWatch Module
```

---

# 🏗️ Infrastructure as Code with Terraform

Terraform was used instead of manually creating AWS resources.

### Terraform workflow

```text
Terraform Configuration
        │
        ▼
terraform init
        │
        ▼
terraform fmt
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
terraform apply
        │
        ▼
AWS Infrastructure
```

### Common commands

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Terraform provides:

- Repeatable infrastructure
- Version-controlled infrastructure
- Consistent environments
- Easier infrastructure management
- Automated cleanup

---

# 🌐 AWS VPC Architecture

The EKS environment was deployed inside an AWS VPC.

The VPC contains:

```text
                    VPC
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
    Public Subnets        Private Subnets
          │                     │
          │                     │
    Internet Gateway       Worker Nodes
                                │
                                ▼
                           Kubernetes
```

Security groups were configured to allow required communication between:

- EKS control plane
- Worker nodes
- Kubernetes workloads
- AWS Load Balancer Controller

---

# ☸️ Amazon EKS

Amazon EKS was used as the Kubernetes platform.

The project uses a self-managed worker node architecture.

```text
             Amazon EKS
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
   Worker Node 1     Worker Node 2
        │                 │
        ▼                 ▼
     Pods              Pods
```

The worker nodes were EC2 instances that joined the EKS cluster.

Node health was verified using:

```bash
kubectl get nodes
```

Expected state:

```text
Ready
```

---

# 🐳 Docker Containerization

Both the frontend and backend were containerized using Docker.

## Backend

The backend uses:

- Node.js
- Express
- Docker

Backend port:

```text
3000
```

Health endpoint:

```text
GET /health
```

Example response:

```json
{
  "status": "healthy"
}
```

Backend Docker flow:

```text
Backend Source Code
        │
        ▼
Dockerfile
        │
        ▼
Docker Build
        │
        ▼
Backend Docker Image
        │
        ▼
Amazon ECR
```

---

# 🎨 Frontend

The frontend uses:

- React
- Vite
- Nginx
- Docker

Production flow:

```text
React Source
     │
     ▼
Vite Build
     │
     ▼
Static Files
     │
     ▼
Nginx
     │
     ▼
Docker Container
```

Frontend port:

```text
80
```

---

# 📦 Amazon ECR

Amazon ECR was used as the container image registry.

The project used separate repositories for:

```text
aws-eks-devops-backend
aws-eks-devops-frontend
```

Image flow:

```text
Docker Build
     │
     ▼
Docker Image
     │
     ▼
Amazon ECR
     │
     ▼
Amazon EKS
```

Docker images were tagged using the GitHub commit SHA.

Example:

```text
aws-eks-devops-backend:<commit-sha>

aws-eks-devops-frontend:<commit-sha>
```

This provides traceability between source code and deployed images.

---

# ☸️ Kubernetes Deployment

The frontend and backend were deployed using Kubernetes Deployments.

## Backend

```text
Backend Deployment
       │
       ├── Backend Pod
       └── Backend Pod
```

Backend Service:

```text
ClusterIP
Port: 3000
```

## Frontend

```text
Frontend Deployment
       │
       ├── Frontend Pod
       └── Frontend Pod
```

Frontend Service:

```text
ClusterIP
Port: 80
```

---

# 🔗 Frontend → Backend Communication

The backend was not directly exposed to the Internet.

The frontend communicates with the backend through the Kubernetes service.

```text
Frontend
    │
    │ HTTP
    ▼
backend:3000
    │
    ▼
Backend Service
    │
    ▼
Backend Pods
```

This provides internal Kubernetes networking between the applications.

---

# 🌐 AWS Load Balancer Controller

The AWS Load Balancer Controller was installed inside the EKS cluster.

Its purpose is to connect Kubernetes Ingress resources with AWS load balancing services.

```text
Kubernetes Ingress
        │
        ▼
AWS Load Balancer Controller
        │
        ▼
AWS Application Load Balancer
```

The controller was configured with an IAM role using OIDC-based authentication.

---

# 🔀 Kubernetes Ingress

A Kubernetes Ingress was created for the frontend.

Configuration:

```text
Scheme       → Internet-facing
Protocol     → HTTP
Port         → 80
Target Type  → IP
Backend      → Frontend Service
```

Traffic flow:

```text
Internet
    │
    ▼
Application Load Balancer
    │
    ▼
Target Group
    │
    ▼
Frontend Service
    │
    ▼
Frontend Pods
```

The ALB target health was successfully verified.

---

# 🔐 Security

Security was implemented using:

- AWS IAM
- IAM roles
- Security groups
- GitHub OIDC
- Kubernetes ClusterIP services

The backend was kept internal rather than directly exposing port `3000` to the Internet.

---

# 🔑 GitHub OIDC Authentication

GitHub Actions was authenticated with AWS using OpenID Connect.

Instead of storing long-lived AWS access keys in GitHub, the workflow obtains temporary credentials through an IAM role.

Authentication flow:

```text
GitHub Actions
      │
      │ OIDC Token
      ▼
GitHub OIDC Provider
      │
      ▼
AWS IAM Role
      │
      ▼
Temporary AWS Credentials
      │
      ▼
AWS Resources
```

The GitHub Actions workflow uses:

```yaml
permissions:
  id-token: write
  contents: read
```

This provides a more secure authentication mechanism for CI/CD.

---

# 🔄 CI/CD Pipeline

The CI/CD pipeline is triggered when code is pushed to the `main` branch.

Complete pipeline:

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
    ▼
Checkout Source Code
    │
    ▼
AWS OIDC Authentication
    │
    ▼
Amazon ECR Login
    │
    ├─────────────────────┐
    │                     │
    ▼                     ▼
Build Backend        Build Frontend
    │                     │
    ▼                     ▼
Push Backend         Push Frontend
to ECR               to ECR
    │                     │
    └──────────┬──────────┘
               │
               ▼
       Configure kubectl
               │
               ▼
          Amazon EKS
               │
               ▼
      Update Deployments
               │
               ▼
       Rolling Deployment
               │
               ▼
       Verify Application
```

---

# ⚙️ GitHub Actions Workflow

The GitHub Actions workflow performs the following operations:

### 1. Checkout

Downloads the repository source code.

### 2. AWS Authentication

Uses GitHub OIDC to assume the AWS IAM role.

### 3. ECR Login

Authenticates Docker with Amazon ECR.

### 4. Backend Build

Builds the backend Docker image.

### 5. Backend Push

Pushes the backend image to ECR.

### 6. Frontend Build

Builds the frontend Docker image.

### 7. Frontend Push

Pushes the frontend image to ECR.

### 8. Configure Kubernetes

Configures `kubectl` to communicate with EKS.

### 9. Backend Deployment

Updates the Kubernetes backend deployment.

### 10. Frontend Deployment

Updates the Kubernetes frontend deployment.

### 11. Rollout Verification

Waits for the Kubernetes deployment to become healthy.

---

# 🔄 Kubernetes Rolling Updates

Kubernetes rolling updates were used for application deployment.

When a new image is deployed:

```text
Old Pods
   │
   ▼
New Pods Created
   │
   ▼
New Pods Become Ready
   │
   ▼
Old Pods Removed
```

This avoids taking the entire application offline during deployment.

---

# 🧪 Application Verification

The following components were verified during deployment:

### Kubernetes Nodes

```bash
kubectl get nodes
```

### Pods

```bash
kubectl get pods
```

### Services

```bash
kubectl get services
```

### Ingress

```bash
kubectl get ingress
```

### Backend Health

```text
GET /health
```

Response:

```json
{
  "status": "healthy"
}
```

### ALB Target Health

The AWS target group was checked to verify that the frontend targets were healthy.

---

# 🗄️ PostgreSQL Status

A PostgreSQL deployment was explored using Kubernetes persistent storage.

The project created:

- PostgreSQL Secret
- PersistentVolumeClaim
- PostgreSQL Deployment

The PVC used the existing:

```text
StorageClass: gp2
Storage Size: 5Gi
```

The PVC remained pending because persistent storage provisioning was not completed.

Therefore PostgreSQL was **not included in the final working application path**.

The final demonstrated architecture focuses on:

```text
Frontend
    +
Backend
    +
Amazon EKS
    +
Kubernetes
    +
AWS ALB
    +
GitHub Actions CI/CD
```

---

# 🧹 AWS Resource Cleanup

After completing the project demonstration, the AWS infrastructure was destroyed to avoid unnecessary ongoing cloud usage.

Terraform cleanup:

```bash
terraform destroy
```

Terraform successfully destroyed:

```text
41 resources
```

The following resources were verified after cleanup:

```text
EKS Clusters              → None
EC2 Worker Instances      → None
ECR Repositories          → None
Application Load Balancer → None
NAT Gateways              → None
```

The GitHub Actions IAM role and GitHub OIDC provider created for the project were also removed.

The GitHub repository and project source code remain available.

---

# 🚀 Complete DevOps Lifecycle

```text
                    PLAN
                      │
                      ▼
                Terraform
                      │
                      ▼
                 AWS VPC
                      │
                      ▼
                 Amazon EKS
                      │
                      ▼
              EC2 Worker Nodes
                      │
                      ▼
                Docker Build
                      │
                      ▼
                 Amazon ECR
                      │
                      ▼
              Kubernetes Deploy
                      │
                      ▼
            AWS Load Balancer
                      │
                      ▼
             Application Testing
                      │
                      ▼
              GitHub Actions
                      │
                      ▼
               GitHub OIDC
                      │
                      ▼
             Automated ECR Push
                      │
                      ▼
             Automated EKS Deploy
                      │
                      ▼
              Rolling Update
                      │
                      ▼
             Application Verify
                      │
                      ▼
              Terraform Destroy
                      │
                      ▼
                AWS Cleanup
```

---

# 📚 Key Learning Outcomes

Through this project, I gained practical experience with:

- Infrastructure as Code using Terraform
- AWS VPC networking
- Amazon EKS
- Kubernetes
- EC2 worker nodes
- Docker containerization
- Amazon ECR
- IAM
- GitHub OIDC
- GitHub Actions
- CI/CD pipelines
- Kubernetes Deployments
- Kubernetes Services
- Kubernetes Ingress
- AWS Load Balancer Controller
- Application Load Balancer
- Security Groups
- Rolling deployments
- Cloud resource cleanup
- DevOps automation

---

# 💼 Project Highlights

| Area | Implementation |
|---|---|
| Infrastructure | Terraform |
| Cloud | AWS |
| Kubernetes | Amazon EKS |
| Compute | EC2 |
| Containers | Docker |
| Registry | Amazon ECR |
| Frontend | React + Vite |
| Backend | Node.js + Express |
| Web Server | Nginx |
| Load Balancer | AWS ALB |
| Kubernetes Integration | AWS Load Balancer Controller |
| CI/CD | GitHub Actions |
| Authentication | GitHub OIDC + AWS IAM |
| Networking | AWS VPC |
| Orchestration | Kubernetes |
| Deployment Strategy | Rolling Update |

---

# 👨‍💻 Author

## Shaik Abzal Sharif

**DevOps Engineer**

---

# 📌 GitHub Repository

[**AWS EKS DevOps Platform**](https://github.com/shaikghb/aws-eks-devops-platform)

---

# ⭐ Final Summary

This project demonstrates a complete DevOps lifecycle starting from infrastructure provisioning and application containerization to Kubernetes deployment, AWS load balancing, secure cloud authentication, automated CI/CD, application verification, and infrastructure cleanup.

The project combines:

```text
Terraform
    +
AWS
    +
Docker
    +
Amazon ECR
    +
Amazon EKS
    +
Kubernetes
    +
AWS ALB
    +
GitHub Actions
    +
GitHub OIDC
```

into a complete end-to-end DevOps platform.