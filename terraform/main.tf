### AWS 用の Terraform 設定
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket  = "tfstate-bucket-715841363431"
    key     = "terraform/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
    profile = "default"
  }
}

provider "aws" {
  region = var.region
}
