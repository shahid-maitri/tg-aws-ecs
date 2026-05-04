data "aws_availability_zones" "available" {}

locals {
  name     = "${var.environment}-${var.app}-vpc"
  vpc_cidr = var.vpc_cidr

  # This will return 6 az, which will create 6 subnets (1 per AZ)
  # azs      = slice(data.aws_availability_zones.available.names, 0, length(data.aws_availability_zones.available.names))
  
  # hardcoding the AZ for easy-ness
  azs = ["us-east-1a"]
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = local.name
  cidr = local.vpc_cidr
  azs  = local.azs

  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets  = []
  database_subnets = []

  enable_nat_gateway      = false
  map_public_ip_on_launch = true

  create_database_subnet_group = false
  manage_default_network_acl   = false
  manage_default_route_table   = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group = true

  default_security_group_ingress = [
    {
      name        = "All Traffic"
      description = "All inbound traffic from within the VPC"
      cidr_blocks = local.vpc_cidr
      protocol    = -1
    }
  ]

  default_security_group_egress = [
    {
      name        = "All Traffic"
      description = "All outbound traffic"
      cidr_blocks = "0.0.0.0/0"
      protocol    = -1
    }
  ]
}