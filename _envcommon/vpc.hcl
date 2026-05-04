locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))

  environment    = local.env_vars.locals.environment
  aws_region     = local.region_vars.locals.aws_region
  aws_account_id = local.env_vars.locals.aws_account_id
  profile        = local.env_vars.locals.profile
  app            = local.app_vars.locals.app_name
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/network"
}

inputs = {
  environment    = local.environment
  aws_region     = local.aws_region
  aws_account_id = local.aws_account_id
  profile        = local.profile
  app            = local.app
}