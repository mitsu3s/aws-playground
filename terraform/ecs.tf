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
