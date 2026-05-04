variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block (e.g. 10.1.0.0/16)"
  type        = string
}

variable "app" {
  description = "Application name"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile"
  type        = string
}