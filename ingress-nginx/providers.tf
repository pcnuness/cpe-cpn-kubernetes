provider "aws" {
  region = local.region
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", local.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = provider.kubernetes.eks.host
    cluster_ca_certificate = provider.kubernetes.eks.cluster_ca_certificate
    exec                   = provider.kubernetes.eks.exec
  }
}
