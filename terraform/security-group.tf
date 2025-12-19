### AWS Playground 用のセキュリティグループ作成 (入口用)
resource "aws_security_group" "aws_playground_ingress_security_group" {
  name        = "${var.project}-${var.environment}-ingress"
  description = "Ingress security group"
  vpc_id      = aws_vpc.aws_playground_vpc.id

  ### 後でルールを追加するので、ここでは空にしておく
  # ingress {}

  ### outbound はまず全許可にしておく
  ### 外部から何かしら取得するなど、運用において必要な場合があるため
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全てのプロトコル
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ingress"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "ingress"
  }
}

### AWS Playground 用のセキュリティグループ作成 (アプリケーション用)
resource "aws_security_group" "aws_playground_app_security_group" {
  name        = "${var.project}-${var.environment}-app"
  description = "Application security group"
  vpc_id      = aws_vpc.aws_playground_vpc.id

  ### 後でルールを追加するので、ここでは空にしておく
  # ingress {}

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-app"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "app"
  }
}

### AWS Playground 用のセキュリティグループ作成 (データベース用)
resource "aws_security_group" "aws_playground_db_security_group" {
  name        = "${var.project}-${var.environment}-db"
  description = "Database security group"
  vpc_id      = aws_vpc.aws_playground_vpc.id

  ### 後でルールを追加するので、ここでは空にしておく
  # ingress {}

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-db"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "db"
  }
}

### AWS Playground 用のセキュリティグループ作成 (EC2用)
resource "aws_security_group" "aws_playground_ec2_security_group" {
  name        = "${var.project}-${var.environment}-ec2"
  description = "EC2 security group for playground"
  vpc_id      = aws_vpc.aws_playground_vpc.id

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_cidr]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ec2"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "ec2"
  }
}

### AWS Playground 用のセキュリティグループ作成 (ECS タスク用)
resource "aws_security_group" "aws_playground_ecs_task_security_group" {
  name        = "${var.project}-${var.environment}-ecs-task"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.aws_playground_vpc.id

  ingress {
    description = "HTTP from my IP only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ip_cidr]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-task"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "ecs-task"
  }
}
