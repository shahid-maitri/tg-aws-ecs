# output "load_balancer_arn" {
#   description = "The ARN of the load balancer"
#   value       = aws_lb.app_lb.arn
# }

# output "load_balancer_dns" {
#   description = "The DNS of the load balancer"
#   value       = aws_lb.app_lb.dns_name
# }

# output "load_balancer_zone_id" {
#   description = "Zone ID of the load balancer"
#   value       = aws_lb.app_lb.zone_id
# }

# output "load_balancer_security_group_id" {
#   description = "Security group ID of the load balancer"
#   value       = aws_security_group.lb_sg.id
# }

output "vpc_id" {
  description = "VPC ID where the service is deployed"
  value       = var.vpc_id
}

# output "private_subnet_ids" {
#   description = "Private subnet IDs where the service is deployed"
#   value       = var.database_subnet_ids
# }

# # Output the S3 location of the .env file
# output "env_file_s3_location" {
#   description = "The S3 location of the environment file"
#   value       = "s3://${aws_s3_object.env_file.bucket}/${aws_s3_object.env_file.key}"
# }