# インスタンス情報の取得
data "aws_ssoadmin_instances" "this" {}

# Admin の Permission Set を定義
resource "aws_ssoadmin_permission_set" "admin" {
  name         = "Admin"
  description  = "Administrator Access"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  session_duration = "PT1H"
}

# Admin に アタッチするポリシーを定義
# AWS 管理ポリシーの AdministratorAccess をアタッチ
resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
