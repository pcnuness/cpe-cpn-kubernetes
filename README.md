
# AWS EKS Addons Module

## Overview

This module provisions and manages additional resources on an AWS EKS cluster, including:
- **AWS Load Balancer Controller**
- **Ingress NGINX**
- **Ingress Configuration with ALB**

The module is designed to simplify deployment for junior analysts by allowing resource configuration through `tfvars` files.

---

## Prerequisites

1. **EKS Cluster** must already be provisioned.
2. **OIDC Provider** configured for the cluster.
3. **ACM Certificates** available for ALB integration.

---

## Directory Structure

```
.
├── main.tf            # Main module configuration
├── vars.tf            # Variable definitions
├── providers.tf       # Provider configuration
├── outputs.tf         # Outputs of the module
├── locals.tf          # Local variables
├── manifests/         # Helm value YAML files
│   ├── values/
│   │   ├── aws-alb-controller.yaml
│   │   └── ingress-nginx.yaml
└── README.md          # Module documentation
```

---

## Inputs

| Name                      | Type      | Description                                                              | Default        | Required |
|---------------------------|-----------|--------------------------------------------------------------------------|----------------|----------|
| `region`                  | `string`  | AWS region for resource provisioning. Allowed values: `us-east-1`, `sa-east-1`. | `us-east-1`    | Yes      |
| `environment`             | `string`  | Deployment environment (e.g., `dev`, `stage`, `prod`).                   | `dev`          | Yes      |
| `cluster_name`            | `string`  | Name of the EKS cluster.                                                 | -              | Yes      |
| `cluster_version`         | `string`  | Kubernetes version for the EKS cluster. Must match `1.x`.                | -              | Yes      |
| `vpc_id`                  | `string`  | VPC ID where the EKS cluster resides.                                    | -              | Yes      |
| `oidc_provider_arn`       | `string`  | ARN of the OIDC provider configured for the EKS cluster.                 | -              | Yes      |
| `alb_resources`           | `map`     | Resource limits and requests for AWS Load Balancer Controller.           | Default values | No       |
| `alb_ingress_annotations` | `map`     | Annotations for configuring ALB ingress.                                 | Default values | No       |

---

## Outputs

| Name                    | Description                                                |
|-------------------------|------------------------------------------------------------|
| `alb_controller_status` | Status of the AWS Load Balancer Controller deployment.     |
| `ingress_nginx_status`  | Status of the Ingress NGINX deployment.                    |
| `eks_cluster_info`      | Information about the EKS cluster, including endpoint.     |
| `alb_ingress_dns`       | DNS hostname of the ALB created for the ingress.           |

---

## Example Usage

### Main Configuration (`main.tf`)

```hcl
module "eks_addons" {
  source = "path/to/this/module"

  region           = var.region
  environment      = var.environment
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = var.vpc_id
  oidc_provider_arn = var.oidc_provider_arn

  alb_ingress_annotations = {
    "alb.ingress.kubernetes.io/scheme"        = "internet-facing"
    "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
    "alb.ingress.kubernetes.io/subnets"       = "subnet-abc123,subnet-def456"
  }
}
```

### Variable Definitions (`vars.tf`)

```hcl
variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "cluster_name" {
  default = "eks-dev-cluster"
}

variable "cluster_version" {
  default = "1.22"
}

variable "vpc_id" {
  default = "vpc-12345678"
}

variable "oidc_provider_arn" {
  default = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/abcdefg123456"
}
```

### Environment-Specific Configuration (`dev.tfvars`)

```hcl
region           = "us-east-1"
environment      = "dev"
cluster_name     = "eks-dev-cluster"
cluster_version  = "1.22"
vpc_id           = "vpc-12345678"
oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/abcdefg123456"

alb_ingress_annotations = {
  "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
  "alb.ingress.kubernetes.io/certificate-arn"          = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
  "alb.ingress.kubernetes.io/subnets"                  = "subnet-abc123,subnet-def456"
  "alb.ingress.kubernetes.io/healthcheck-path"         = "/healthz"
  "alb.ingress.kubernetes.io/actions.ssl-redirect"     = "{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}"
}
```

---

## Terraform Commands

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Validate the configuration:
   ```bash
   terraform validate
   ```

3. Plan the resources:
   ```bash
   terraform plan -var-file="./env/dev.tfvars"
   ```

4. Apply the changes:
   ```bash
   terraform apply -var-file="./env/dev.tfvars"
   ```

5. Check outputs:
   ```bash
   terraform output
   ```

---