### 利用可能なゾーンの取得
data "aws_availability_zones" "available" {
  state = "available"
}

### 先頭から2つの利用可能なゾーンをローカル変数に格納
locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

### AWS Playground 用の VPC 作成
resource "aws_vpc" "aws_playground_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

### AWS Playground 用のパブリックサブネットを2つ作成
### 1つ目の subnet は 1つ目の availability zone に、2つ目の subnet は 2つ目の availability zone に配置
resource "aws_subnet" "aws_playground_public_subnet" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.aws_playground_vpc.id
  availability_zone       = local.availability_zones[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) # /16+8 = /24 からサブネットを分割
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-${count.index}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}
