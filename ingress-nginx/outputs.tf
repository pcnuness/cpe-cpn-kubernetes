output "eks_cluster_info" {
  value = {
    cluster_name = local.eks.cluster_name
    region       = var.region
    endpoint     = data.aws_eks_cluster.cluster.endpoint
  }
  description = "Information about the EKS cluster"
}

output "alb_ingress_dns" {
  value       = kubernetes_ingress_v1.ingress_forwarding.status[0].load_balancer[0].ingress[0].hostname
  description = "DNS hostname of the ALB ingress"
}
