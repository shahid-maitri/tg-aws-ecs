locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))

  environment = local.env_vars.locals.environment
  aws_region  = local.region_vars.locals.aws_region
  profile     = local.env_vars.locals.profile
  app         = local.app_vars.locals.app_name
}

terraform {
  source   = "${dirname(find_in_parent_folders("root.hcl"))}/modules/ec2"
  # source = "${get_repo_root()}/modules/ec2"
}

dependency "vpc" {
  config_path = "../../base-infra/vpc"

  mock_outputs = {
    vpc_id         = "vpc-00000000"
    vpc_cidr_block = "10.0.0.0/16"
    public_subnets = ["subnet-00000000"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  # Common
  environment = local.environment
  aws_region  = local.aws_region
  profile     = local.profile
  app         = local.app

  # From VPC module outputs
  vpc_id         = dependency.vpc.outputs.vpc_id
  vpc_cidr_block = dependency.vpc.outputs.vpc_cidr_block
  public_subnets = dependency.vpc.outputs.public_subnets

  # EC2 config(inputs) is in child modules
}