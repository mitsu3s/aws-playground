### ECS クラスターを作成
### 論理的なサービスのグループ
resource "aws_ecs_cluster" "aws_playground_ecs_cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-cluster"
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

### Nginx の ECS サービスを作成
### ECS Service は Task を何個・どのネットワークで・どう維持するかを定義するもの
resource "aws_ecs_service" "aws_playground_nginx_service" {
  name            = "${var.project}-${var.environment}-nginx"
  cluster         = aws_ecs_cluster.aws_playground_ecs_cluster.id
  task_definition = aws_ecs_task_definition.aws_playground_nginx_task.arn
  desired_count   = 2 # Task を 2 個維持する → 落ちたら自動復旧する
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.aws_playground_public_subnet[*].id
    security_groups  = [aws_security_group.aws_playground_ecs_task_security_group.id]
    assign_public_ip = true
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
