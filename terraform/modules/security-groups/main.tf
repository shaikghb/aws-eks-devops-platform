resource "aws_security_group" "node" {
  name        = "${var.project_name}-${var.environment}-node-sg"
  description = "Security group for self-managed EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Kubernetes and application traffic between nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [ingress]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-node-sg"
  }
}