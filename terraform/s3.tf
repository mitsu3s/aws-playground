### tfstate を保存する S3 バケットの定義
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = var.tfstate_bucket_name

  # 識別のためのタグ
  tags = {
    Project     = var.project
    Purpose     = "terraform-state"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
}

### 履歴の有効化
### state の履歴を残して、誤って上書きした場合に復元できるようにする
resource "aws_s3_bucket_versioning" "tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

### パブリックなアクセスをブロック
### デフォルトで有効化されているが、明示的に定義しておく
resource "aws_s3_bucket_public_access_block" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

### 暗号の有効化
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
