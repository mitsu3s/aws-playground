### EC2 のテンプレート (Amazon Machine Image) を取得
### SSM パラメータストアから取得
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

### EC2 のインスタンスを作成
resource "aws_instance" "aws_playground_ec2" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.aws_playground_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.aws_playground_ec2_security_group.id]
  key_name               = var.ssh_key_name

  tags = {
    Name        = "${var.project}-${var.environment}-playground-ec2"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

### ECS のタスク定義を作成
### EC2 でいうところの AMI とかインスタンスタイプみたいな、設計図のようなもの
resource "aws_ecs_task_definition" "aws_playground_nginx_task" {
  family                   = "${var.project}-${var.environment}-nginx"
  network_mode             = "awsvpc"    # IP とか Security Group を持つのが ENIで、ENI - Task - Container の関係になる
  requires_compatibilities = ["FARGATE"] # Fargate を使う
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:latest"

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      essential = true
    }
  ])

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
