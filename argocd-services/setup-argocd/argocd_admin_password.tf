# ==================================================================
# RANDOM - ARGOCD ADMIN PASSWORD
# ==================================================================

resource "random_password" "argocd_admin_password" {
  length           = 28
  special          = true
  override_special = "(_="
}

resource "null_resource" "argocd_admin_password" {
  triggers = {
    plain    = random_password.argocd_admin_password.result
    hash     = bcrypt(random_password.argocd_admin_password.result)
    modified = timestamp()
  }
  lifecycle {
    ignore_changes = [
      triggers["hash"],
      triggers["modified"]
    ]
  }
}

# ==================================================================
# MODULE AWS SECRETS MANAGER - ARGOCD
# ==================================================================

module "secrets_manager_argocd" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.1"

  name                    = "/tools/gitops/argocd"
  description             = "Information about ArgoCD login"
  recovery_window_in_days = 7
  block_public_policy     = true
  secret_string = jsonencode({
    ARGOCD_ADMIN_PASSWORD = random_password.argocd_admin_password.result
    ARGOCD_ADMIN_USERNAME = "admin"
    ARGOCD_URL            = "argocd.${local.aws_dns_default}"
  })
}
