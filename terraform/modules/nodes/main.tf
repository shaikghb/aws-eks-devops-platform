data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-${var.environment}-eks-node-"
  instance_type = var.node_instance_type
  image_id      = data.aws_ssm_parameter.eks_ami.value
  
  lifecycle {
    ignore_changes = [image_id]
  }

  iam_instance_profile {
    name = var.node_instance_profile_name
  }

  vpc_security_group_ids = [var.node_security_group_id]

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${var.cluster_endpoint}
    certificateAuthority: ${var.cluster_certificate_authority}
    cidr: ${var.cluster_service_cidr}

--BOUNDARY--
EOF
  )

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-eks-node"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.project_name}-${var.environment}-eks-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-eks-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}