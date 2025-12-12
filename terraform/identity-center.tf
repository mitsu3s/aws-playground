# 基本情報取得
data "aws_ssoadmin_instances" "this" {}
data "aws_caller_identity" "current" {}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.this.arns[0]
  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]
}

# Identity Group の Admins グループを定義
resource "aws_identitystore_group" "admins" {
  identity_store_id = local.identity_store_id
  display_name      = "admins"
  description       = "Administrators Group"
}

# Admin の Permission Set を定義
resource "aws_ssoadmin_permission_set" "admins" {
  name             = "Admins"
  description      = "Administrators Access"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT4H" # セッションの長さ
}

# Admin に アタッチするポリシーを定義
# AWS 管理ポリシーの AdministratorAccess をアタッチ
resource "aws_ssoadmin_managed_policy_attachment" "admins_access" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admins.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Admin グループに Permission Set をアサイン
resource "aws_ssoadmin_account_assignment" "admins_to_account" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admins.arn
  principal_type     = "GROUP"
  principal_id       = aws_identitystore_group.admins.group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = data.aws_caller_identity.current.account_id
}
