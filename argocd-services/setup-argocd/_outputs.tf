# ==================================================================
# OUTPUTS - AWS DEFAULT
# ==================================================================

output "aws_account_id" {
  description = "Selected AWS Account ID"
  value       = local.aws_account_id
}

output "aws_region" {
  description = "Details about selected AWS region"
  value       = data.aws_region.current.name
}

# ==================================================================
# OUTPUTS - AWS EKS
# ==================================================================

output "cluster_endpoint" {
  description = "The endpoint for your Kubernetes API server"
  value       = local.aws_eks_cluster_endpoint
}

output "cluster_name" {
  description = "The EKS cluster name"
  value       = local.aws_eks_cluster_name
}
