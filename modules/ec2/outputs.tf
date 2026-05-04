output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_name" {
  description = "Name tag of the EC2 instance"
  value       = "${var.environment}-${var.app}-${var.instance_name}"
}

output "instance_type" {
  description = "Instance type of the EC2 instance"
  value       = aws_instance.this.instance_type
}

output "ami_id" {
  description = "AMI ID used by the EC2 instance"
  value       = aws_instance.this.ami
}

output "key_pair_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_pem" {
  description = "Private key PEM — use to SSH into the instance (sensitive)"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the security group attached to the instance"
  value       = aws_security_group.this.id
}

output "subnet_id" {
  description = "Subnet ID where the instance is deployed"
  value       = aws_instance.this.subnet_id
}

# output "iam_role_arn" {
#   description = "ARN of the IAM role attached to the instance"
#   value       = aws_iam_role.this.arn
# }

# output "instance_profile_name" {
#   description = "Name of the IAM instance profile"
#   value       = aws_iam_instance_profile.this.name
# }