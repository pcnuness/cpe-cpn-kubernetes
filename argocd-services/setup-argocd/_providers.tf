# ==================================================================
# PROVIDER AWS - DEFAULT
# ==================================================================

provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      "metadata:managed-by" = "terraform"
    }
  }
}

# ==================================================================
# PROVIDER HELM
# ==================================================================

provider "helm" {
  kubernetes {
    host                   = local.aws_eks_cluster_endpoint
    cluster_ca_certificate = local.aws_eks_cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", local.aws_eks_cluster_name]
    }
  }
}

# ==================================================================
# PROVIDER OTHRERS
# ==================================================================

provider "null" {}
provider "random" {}
