variable "region" {
  description = "AWS region where resources will be provisioned"
  type        = string

  validation {
    condition     = contains(["us-east-1", "sa-east-1"], var.region)
    error_message = "The region must be either 'us-east-1' or 'sa-east-1'."
  }

  default = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Kubernetes Name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  validation {
    condition     = can(regex("^1\\.(\\d{1,2})$", var.cluster_version))
    error_message = "Cluster version must be in the format '1.x'"
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "VPC ID must be in the format 'vpc-xxxxxxxxxxxxxxxxx'"
  }
}

variable "oidc_provider_arn" {
  description = "AWS ARN Provider OIDC"
  type        = string
}


# AWS ALB Resources
variable "alb_resources" {
  description = "Resource limits and requests for ALB controller"
  default = {
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

# Ingress-nginx
variable "alb_ingress_annotations" {
  description = "Annotations for ALB ingress"
  type        = map(string)
  default = {
    "alb.ingress.kubernetes.io/actions.ssl-redirect"     = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
    "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
    "alb.ingress.kubernetes.io/target-type"              = "instance"
    "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=600"
    "alb.ingress.kubernetes.io/healthcheck-path"         = "/"
    "alb.ingress.kubernetes.io/listen-ports"             = jsonencode([{ "HTTP" = 80, "HTTPS" = 443 }])
    "alb.ingress.kubernetes.io/success-codes"            = "200,404"
    "alb.ingress.kubernetes.io/certificate-arn"          = "arn:aws:acm:us-east-1:YOUR_CERT_ARN"
    "alb.ingress.kubernetes.io/subnets"                  = "YOUR_SUBNETS"
  }
}