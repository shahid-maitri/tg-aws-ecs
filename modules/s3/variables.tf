variable "environment" {
  description = "Environment name (dev, prod, etc)"
  type        = string
}

variable "app" {
  description = "Application name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = true
}

variable "enable_kms" {
  description = "Use KMS encryption instead of AES256"
  type        = bool
  default     = false
}