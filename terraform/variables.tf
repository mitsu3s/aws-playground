### 変数定義
variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "tfstate_bucket_name" {
  type        = string
  description = "S3 bucket name for Terraform state"

}

variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}
