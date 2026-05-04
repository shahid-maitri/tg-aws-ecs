variable "name" {
  type = string
}

variable "environment" {
  type    = string
  default = ""
}

variable "app" {
  type    = string
  default = ""
}

variable "tags" {
  description = "Additional tags to apply to the ECS cluster"
  type        = map(string)
  default     = {}
}