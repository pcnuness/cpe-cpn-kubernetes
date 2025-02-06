# ==================================================================
# DATAS - AWS
# ==================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ==================================================================
# DATAS - AWS EKS
# ==================================================================

data "aws_eks_cluster" "cluster" {
  name = local.aws_eks_cluster_name
}

# ==================================================================
# DATAS - AWS NETWORK
# ==================================================================

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = local.aws_network_subnet_public_names
  }
}
