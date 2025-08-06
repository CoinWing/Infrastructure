terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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