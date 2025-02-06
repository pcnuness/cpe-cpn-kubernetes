# ==================================================================
# HELM INSTALL - ARGOCD
# ==================================================================

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.8.0"
  max_history      = 5
  timeout          = 600
  wait             = false
  values = [
    templatefile("${path.root}/manifests/argocd.yaml.tftpl", {
      argocd_admin_password_mtime = null_resource.argocd_admin_password.triggers.modified
      argocd_admin_password       = null_resource.argocd_admin_password.triggers.hash
      argocd_url                  = "argocd.${local.aws_dns_default}"
      aws_acm_arn                 = local.aws_certificate_arn
      aws_subnets_ids             = join(", ", local.aws_network_subnet_public_ids)
      env_name                    = local.aws_environment
      env_abbreviation            = upper(substr(local.aws_environment, 0, 1))
    })
  ]
}