output "bucket_name" {
  description = "S3 bucket name"
  value       = module.s3_bucket.s3_bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3_bucket.s3_bucket_arn
}

output "kms_key_arn" {
  description = "KMS key ARN (null if not using KMS)"
  value       = var.enable_kms ? module.kms_key[0].key_arn : null
}