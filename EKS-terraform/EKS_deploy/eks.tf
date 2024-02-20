resource "aws_iam_role" "cluster-role" {
  name = "${var.cluster_name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "EKSClusterPolicy-attch" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_eks_cluster" "EKS-cluster" {
  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    subnet_ids = [
      "${var.pvt-subnet-a-id}",
      "${var.pvt-subnet-b-id}",
      "${var.pub-subnet-a-id}",
      "${var.pub-subnet-b-id}"
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.EKSClusterPolicy-attch]
}