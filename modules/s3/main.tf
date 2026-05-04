module "kms_key" {
  count   = var.enable_kms ? 1 : 0
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  description = "KMS key for ${var.environment}-${var.app}-s3-bucket"

  aliases = [
    "${var.environment}-${var.app}-s3-kms-key"
  ]
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.6.0"

  bucket = "${var.environment}-${var.app}-bucket"

  versioning = {
    status = var.versioning
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = var.enable_kms ? "aws:kms" : "AES256"
        kms_master_key_id = var.enable_kms ? module.kms_key[0].key_arn : null
      }

      bucket_key_enabled = var.enable_kms ? true : false
    }
  }

  tags = {
    Environment = var.environment
    Application = var.app
    ManagedBy   = "terraform"
  }
}

