################### Common Variables #######################

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "app" {
  description = "Application name (used in resource naming)"
  type        = string
}

################### Network Variables #######################

variable "vpc_id" {
  description = "ID of the VPC to deploy into"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the application VPC (used in SG ingress)"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}


################### EC2 Variables #######################

variable "instance_name" {
  description = "Short name identifier for the instance, used in all resource names"
  type        = string
  default     = "operation"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.micro"
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "volume_type" {
  description = "Root EBS volume type (gp3 recommended)"
  type        = string
  default     = "gp3"
}