resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 14

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-logs"
  }
}
