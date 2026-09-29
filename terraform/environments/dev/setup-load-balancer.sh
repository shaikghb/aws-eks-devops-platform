#!/bin/bash

set -e

# ============================================================
# AWS EKS DEVOPS PLATFORM
# AWS Load Balancer Controller - Complete Setup
# ============================================================

CLUSTER_NAME="aws-eks-devops-platform-dev-eks"
AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="291761344414"
VPC_ID="vpc-0b86b6f7f65441dd0"

PUBLIC_SUBNET_1="subnet-0cdc0c1259c790754"
PUBLIC_SUBNET_2="subnet-0ab33e83f85f63e69"

PRIVATE_SUBNET_1="subnet-026e8cfbb6f3aec63"
PRIVATE_SUBNET_2="subnet-06ff173439bbfe617"

ROLE_NAME="AmazonEKSLoadBalancerControllerRole"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"

echo "=========================================="
echo " AWS EKS Load Balancer Controller Setup"
echo "=========================================="

# ------------------------------------------------------------
# 1. Get EKS OIDC information
# ------------------------------------------------------------

echo ""
echo "[1/12] Getting EKS OIDC information..."

OIDC_ISSUER=$(aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --query 'cluster.identity.oidc.issuer' \
  --output text)

OIDC_HOSTPATH="${OIDC_ISSUER#https://}"

echo "OIDC Issuer:"
echo "$OIDC_ISSUER"

# ------------------------------------------------------------
# 2. Find OIDC Provider ARN
# ------------------------------------------------------------

echo ""
echo "[2/12] Finding OIDC provider..."

OIDC_PROVIDER_ARN=$(aws iam list-open-id-connect-providers \
  --query "OpenIDConnectProviderList[].Arn" \
  --output text | tr '\t' '\n' | grep "$OIDC_HOSTPATH" || true)

if [ -z "$OIDC_PROVIDER_ARN" ]; then
    echo "ERROR: OIDC provider not found."
    echo "Run terraform apply first."
    exit 1
fi

echo "OIDC Provider:"
echo "$OIDC_PROVIDER_ARN"

# ------------------------------------------------------------
# 3. Download AWS Load Balancer Controller IAM Policy
# ------------------------------------------------------------

echo ""
echo "[3/12] Downloading IAM policy..."

curl -L \
  -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.14.1/docs/install/iam_policy.json

echo "IAM policy downloaded."

# ------------------------------------------------------------
# 4. Create IAM Policy
# ------------------------------------------------------------

echo ""
echo "[4/12] Creating IAM policy..."

POLICY_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${POLICY_NAME}"

if aws iam get-policy \
    --policy-arn "$POLICY_ARN" \
    --region "$AWS_REGION" >/dev/null 2>&1; then

    echo "IAM policy already exists."

else

    aws iam create-policy \
      --policy-name "$POLICY_NAME" \
      --policy-document file://iam_policy.json \
      --region "$AWS_REGION"

    echo "IAM policy created."

fi

# ------------------------------------------------------------
# 5. Create Trust Policy
# ------------------------------------------------------------

echo ""
echo "[5/12] Creating IAM trust policy..."

cat > lbc-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${OIDC_PROVIDER_ARN}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_HOSTPATH}:aud": "sts.amazonaws.com",
          "${OIDC_HOSTPATH}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
EOF

echo "Trust policy created."

# ------------------------------------------------------------
# 6. Create IAM Role
# ------------------------------------------------------------

echo ""
echo "[6/12] Creating IAM role..."

if aws iam get-role \
    --role-name "$ROLE_NAME" \
    --region "$AWS_REGION" >/dev/null 2>&1; then

    echo "IAM role already exists."

else

    aws iam create-role \
      --role-name "$ROLE_NAME" \
      --assume-role-policy-document file://lbc-trust-policy.json \
      --region "$AWS_REGION"

    echo "IAM role created."

fi

# ------------------------------------------------------------
# 7. Attach IAM Policy
# ------------------------------------------------------------

echo ""
echo "[7/12] Attaching IAM policy to role..."

aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn "$POLICY_ARN" \
  --region "$AWS_REGION"

echo "Policy attached."

# ------------------------------------------------------------
# 8. Tag Public and Private Subnets
# ------------------------------------------------------------

echo ""
echo "[8/12] Tagging subnets..."

aws ec2 create-tags \
  --resources \
  "$PUBLIC_SUBNET_1" \
  "$PUBLIC_SUBNET_2" \
  --tags Key=kubernetes.io/role/elb,Value=1 \
  --region "$AWS_REGION"

aws ec2 create-tags \
  --resources \
  "$PRIVATE_SUBNET_1" \
  "$PRIVATE_SUBNET_2" \
  --tags Key=kubernetes.io/role/internal-elb,Value=1 \
  --region "$AWS_REGION"

echo "Subnet tags configured."

# ------------------------------------------------------------
# 9. Create Kubernetes Service Account
# ------------------------------------------------------------

echo ""
echo "[9/12] Creating Kubernetes service account..."

kubectl create serviceaccount \
  aws-load-balancer-controller \
  -n kube-system \
  --dry-run=client \
  -o yaml > aws-load-balancer-controller-service-account.yaml

cat > aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-load-balancer-controller
  namespace: kube-system
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${AWS_ACCOUNT_ID}:role/${ROLE_NAME}
EOF

kubectl apply \
  -f aws-load-balancer-controller-service-account.yaml

echo "Service account configured."

# ------------------------------------------------------------
# 10. Install Helm Repository
# ------------------------------------------------------------

echo ""
echo "[10/12] Configuring Helm..."

helm repo add eks https://aws.github.io/eks-charts 2>/dev/null || true

helm repo update eks

echo "Helm repository configured."

# ------------------------------------------------------------
# 11. Install AWS Load Balancer Controller
# ------------------------------------------------------------

echo ""
echo "[11/12] Installing AWS Load Balancer Controller..."

if helm status aws-load-balancer-controller \
    -n kube-system >/dev/null 2>&1; then

    echo "Controller already installed."
    echo "Upgrading controller..."

    helm upgrade aws-load-balancer-controller \
      eks/aws-load-balancer-controller \
      -n kube-system \
      --version 1.14.0 \
      --set clusterName="$CLUSTER_NAME" \
      --set region="$AWS_REGION" \
      --set vpcId="$VPC_ID" \
      --set serviceAccount.create=false \
      --set serviceAccount.name=aws-load-balancer-controller

else

    helm install aws-load-balancer-controller \
      eks/aws-load-balancer-controller \
      -n kube-system \
      --version 1.14.0 \
      --set clusterName="$CLUSTER_NAME" \
      --set region="$AWS_REGION" \
      --set vpcId="$VPC_ID" \
      --set serviceAccount.create=false \
      --set serviceAccount.name=aws-load-balancer-controller

fi

echo "AWS Load Balancer Controller installed."

# ------------------------------------------------------------
# 12. Create ALB Ingress
# ------------------------------------------------------------

echo ""
echo "[12/12] Creating ALB Ingress..."

mkdir -p ../../../../kubernetes/ingress

cat > ../../../../kubernetes/ingress/alb.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-ingress
  namespace: default
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend
                port:
                  number: 80
EOF

kubectl apply \
  -f ../../../../kubernetes/ingress/alb.yaml

echo ""
echo "=========================================="
echo " SETUP COMPLETE"
echo "=========================================="

echo ""
echo "Checking controller..."
kubectl get deployment \
  -n kube-system \
  aws-load-balancer-controller

echo ""
echo "Checking controller pods..."
kubectl get pods \
  -n kube-system \
  -l app.kubernetes.io/name=aws-load-balancer-controller

echo ""
echo "Checking ingress..."
kubectl get ingress frontend-ingress

echo ""
echo "Checking services..."
kubectl get svc

echo ""
echo "Checking nodes..."
kubectl get nodes

echo ""
echo "=========================================="
echo " ALB hostname may take a few minutes."
echo " Run:"
echo ""
echo "kubectl get ingress frontend-ingress"
echo ""
echo "=========================================="
