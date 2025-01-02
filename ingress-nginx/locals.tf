locals {
  region      = var.region
  environment = var.environment
  eks = {
    cluster_name      = var.cluster_name
    cluster_version   = var.cluster_version
    vpc_id            = var.vpc_id
    oidc_provider_arn = var.oidc_provider_arn
  }
  alb_ingress_annotations = merge({
    "alb.ingress.kubernetes.io/actions.ssl-redirect" = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
  }, var.alb_ingress_annotations)
  
}