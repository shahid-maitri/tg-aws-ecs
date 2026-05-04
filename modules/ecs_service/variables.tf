variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "environemnt"
  type        = string
}

variable "app" {
  description = "app name"
  type        = string
}

variable "profile" {
  description = "profile"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the ECS service"
  type        = map(string)
  default     = {}
}


# variable "input-bucket" {
#   description = "input-bucket name"
#   type        = string
# }

# variable "workspace-bucket" {
#   description = "workspace-bucket name"
#   type        = string
# }

# variable "logos-bucket" {
#   description = "logos-bucket name"
#   type        = string
# }

# variable "env-file-bucket" {
#   description = "workspace-bucket name"
#   type        = string
# }

# variable "input-bucket-kms-key-arn" {
#   description = "KMS key ARN for input bucket encryption"
#   type        = string
# }

# variable "workspace-bucket-kms-key-arn" {
#   description = "KMS key ARN for workspace bucket encryption"
#   type        = string
# }







variable "ecs_task" {
  type = object({
    family                   = string
    container_name           = string
    container_image          = string
    cpu                      = number
    memory                   = number
    requires_compatibilities = list(string)
    network_mode             = string
    container_image_port     = number
    log_group_name           = string
  })
}

# variable "load_balancer" {
#   type = object({
#     internal           = bool
#     load_balancer_type = string
#     health_check_path  = string
#   })
# }

variable "ecs_service" {
  type = object({
    name          = string
    desired_count = number
    launch_type   = string
  })
}

variable "public_ip" {
  description = "Enable public ip or not"
  type        = bool
  default     = true
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster where the service will run"
  type        = string
}






################### VPC Variables #######################
variable "vpc_id" {
  description = "ID of the VPC where ECS service will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for load balancer"
  type        = list(string)
}

