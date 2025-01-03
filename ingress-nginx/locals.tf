locals {
  region      = var.region
  environment = var.environment

  eks = {
    cluster_name      = var.cluster_name
    cluster_version   = var.cluster_version
    vpc_id            = var.vpc_id
    oidc_provider_arn = var.oidc_provider_arn
    certificate_id    = var.acm_certificate_id
  }

  alb_ingress_annotations = merge(
    {
      "alb.ingress.kubernetes.io/certificate-arn"      = "arn:aws:acm:${local.region}:${data.aws_caller_identity.current.account_id}:certificate/${local.eks.certificate_id}"
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\":8080,\"HTTPS\":4443}]",
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
    },
    var.alb_ingress_annotations
  )
}