provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "the-last-straw-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create IAM Role for EKS
resource "aws_iam_role" "the-last-straw-eks" {
  name = "${var.cluster_name}-eks"

  assume_role_policy = jsonencode(
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
})
}

# Attach EKS Policies to the IAM Role
resource "aws_iam_role_policy_attachment" "the-last-straw-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.the-last-straw-eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "the-last-straw-AmazonEKSServicePolicy" {
  role       = aws_iam_role.the-last-straw-eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


# Create EKS Cluster
resource "aws_eks_cluster" "the-last-straw-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.the-last-straw-eks.arn
  version = "1.30"
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
}

resource "aws_iam_role_policy_attachment" "the-last-straw-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.the-last-straw-eks-node.name
}

resource "aws_iam_role_policy_attachment" "the-last-straw-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.the-last-straw-eks-node.name
}
resource "aws_iam_role_policy_attachment" "the-last-straw-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.the-last-straw-eks-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Create Node Group
resource "aws_eks_node_group" "the-last-straw-node-group" {
  cluster_name    = aws_eks_cluster.the-last-straw-cluster.name
  node_group_name = "${var.cluster_name}-workers"
  node_role_arn   = aws_iam_role.the-last-straw-eks-node.arn
  version         = aws_eks_cluster.the-last-straw-cluster.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  ami_type = "AL2_x86_64"
  subnet_ids = var.subnet_ids
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = var.desired_capacity
    max_size = var.max_capacity
    min_size = var.min_capacity
  }

  instance_types = ["t3.medium"]
  depends_on = [
    aws_iam_role_policy_attachment.the-last-straw-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.the-last-straw-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.the-last-straw-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Create IAM Role for EC2
resource "aws_iam_role" "the-last-straw-eks-node" {
  name = "${var.cluster_name}-eks-node"

  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
})
}

# Create RDS
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  max_allocated_storage = 100
  engine               = "postgres"
  engine_version       = "13.3"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  publicly_accessible  = false
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = aws_db_subnet_group.default.name

  skip_final_snapshot = true

  tags = {
    Name = "postgres-rds"
  }
}