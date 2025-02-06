# ====================================================================
# GLOBAL LOCALS
# ====================================================================

locals {
  # ==================================================================
  # AWS GENERAL
  # ==================================================================
  aws_region          = "us-east-1"
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_dns_default     = "" # Domain Using
  aws_environment     = "develop"
  aws_certificate_arn = "arn:aws:acm:${local.aws_region}:${local.aws_account_id}:certificate/<ACM>"
  # ==================================================================
  # AWS EKS
  # ==================================================================
  aws_eks_cluster_name           = "eks-${local.aws_environment}-services"
  aws_eks_cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
  aws_eks_cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  # ==================================================================
  # AWS NETWORK
  # ==================================================================
  aws_network_subnet_public_names = [] # Subnet Public List
  aws_network_subnet_public_ids = data.aws_subnets.public.ids
}
