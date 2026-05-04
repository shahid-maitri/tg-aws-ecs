module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 3.2"

  repository_name = "${var.app}-${var.environment}-repo"

  repository_image_tag_mutability = var.image_tag_mutability
  repository_image_scan_on_push   = var.scan_on_push
  repository_encryption_type      = var.encryption_type
  repository_kms_key              = var.kms_key_arn
  repository_force_delete         = var.force_delete

  # Lifecycle policy
  create_lifecycle_policy = var.enable_lifecycle_policy
  repository_lifecycle_policy = var.enable_lifecycle_policy ? jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  }) : null

  tags = var.tags
}
