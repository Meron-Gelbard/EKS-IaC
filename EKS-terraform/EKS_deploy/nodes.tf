resource "aws_iam_role" "node-role" {
  name = "eks-nodes-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "EKSWorkerNodePolicy-attch" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "EKS_CNI_Policy-attch" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "EKS-nodes-EC2ContainerRegistryRead-attch" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.EKS-cluster.name
  node_group_name = "EKS-worker-nodes"
  node_role_arn   = aws_iam_role.node-role.arn

  subnet_ids = [
    "${var.pvt-subnet-a-id}",
    "${var.pvt-subnet-b-id}"
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = var.node-count
    max_size     = var.node-count + 1
    min_size     = var.node-count - 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.cluster_name}-node"
  }
}
