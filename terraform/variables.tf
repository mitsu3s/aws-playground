### 変数定義
variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "tfstate_bucket_name" {
  type        = string
  description = "S3 bucket name for Terraform state"

}
