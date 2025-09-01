terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = { 
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # backend.hcl 파일에서 설정한 값을 사용하고, 이 파일에서는 설정 값을 직접 입력하지 않음
    # terraform init -backend-config=backend.hcl
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes  {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec  {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}