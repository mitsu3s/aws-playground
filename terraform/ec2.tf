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
