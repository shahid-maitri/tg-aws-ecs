output "repository_arn" {
  description = "Full ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "repository_url" {
  description = "URL of the ECR repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)"
  value       = module.ecr.repository_url
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr.repository_registry_id
}
