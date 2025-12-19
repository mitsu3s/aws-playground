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

### AWS Playground 用のインターネットゲートウェイ作成
resource "aws_internet_gateway" "aws_playground_internet_gateway" {
  vpc_id = aws_vpc.aws_playground_vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-internet-gateway"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

### AWS Playground 用のルートテーブル作成（パブリック）
resource "aws_route_table" "aws_playground_public_route_table" {
  vpc_id = aws_vpc.aws_playground_vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-public-route-table"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}

### 上のルートテーブルの動きを定義
### 上のルートテーブルを使うと、インターネットゲートウェイを介して外部へでていく
resource "aws_route" "aws_playground_public_route" {
  route_table_id         = aws_route_table.aws_playground_public_route_table.id
  destination_cidr_block = "0.0.0.0/0" # 全ての宛先
  gateway_id             = aws_internet_gateway.aws_playground_internet_gateway.id
}

### 二つのパブリックサブネットを上のルートテーブルに関連付け
### 両方のサブネットはインターネットゲートウェイを介して外部へでていく動きをする
resource "aws_route_table_association" "aws_playground_public_route_table_association" {
  count          = length(aws_subnet.aws_playground_public_subnet)
  subnet_id      = aws_subnet.aws_playground_public_subnet[count.index].id
  route_table_id = aws_route_table.aws_playground_public_route_table.id
}
