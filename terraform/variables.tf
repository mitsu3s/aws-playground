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

variable "ip_cidr" {
  type        = string
  description = "Your public IP in CIDR notation"
}

variable "ssh_key_name" {
  type        = string
  description = "EC2 key pair name for SSH access"
}

variable "ecs_task_cpu" {
  type        = number
  description = "CPU units for the ECS task"
}

variable "ecs_task_memory" {
  type        = number
  description = "Memory in MB for the ECS task"
}
