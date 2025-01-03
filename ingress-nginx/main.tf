module "eks_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = local.eks.cluster_name
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_version   = local.eks.cluster_version
  oidc_provider_arn = local.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    name          = "aws-load-balancer-controller"
    namespace     = "kube-system"
    chart         = "aws-load-balancer-controller"
    chart_version = "1.7.1"
    repository    = "https://aws.github.io/eks-charts"
    lint          = true
    values = [
      templatefile("${path.root}/manifests/values/aws-alb-controller.yaml.tftpl", {
        region        = local.region
        vpc_id        = local.eks.vpc_id
        alb_resources = var.alb_resources
      })
    ]
  }

  enable_ingress_nginx = true
  ingress_nginx = {
    name          = "ingress-nginx"
    chart_version = "4.8.2"
    repository    = "https://kubernetes.github.io/ingress-nginx"
    namespace     = "ingress-nginx"
    lint          = false
    values        = [templatefile("${path.root}/manifests/values/ingress-nginx.yaml", {})]
    wait          = false
  }
}

resource "time_sleep" "addons" {
  create_duration  = "60s"
  destroy_duration = "60s"
  depends_on = [
    module.eks_addons
  ]
}

resource "null_resource" "addons_blocker" {
  depends_on = [
    time_sleep.addons
  ]
}

resource "kubernetes_ingress_v1" "ingress_forwarding" {
  metadata {
    name      = "forwarding-ingress-nginx"
    namespace = "ingress-nginx"
    labels = {
      app = "forwarding-ingress-nginx"
    }
    annotations = local.alb_ingress_annotations
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "ssl-redirect"
              port {
                name = "use-annotation"
              }
            }
          }
        }
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "ingress-nginx-controller"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
  depends_on = [
    null_resource.addons_blocker
  ]
}