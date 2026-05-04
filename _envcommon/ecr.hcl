############################
# Module source
############################
terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/ecr"
}


locals {
  environment_vars  = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  app_vars          = read_terragrunt_config(find_in_parent_folders("app.hcl"))

  # Extract out common variables for reuse
  environment       = local.environment_vars.locals.environment
  region            = local.region_vars.locals.aws_region
  app               = local.app_vars.locals.app_name
  profile           = local.environment_vars.locals.profile
}

############################
# Inputs
############################
inputs = {
  environment    = local.environment
  app            = local.app
  region         = local.region
  profile        = local.profile

  tags = {
    Environment = local.environment
    App         = local.app
  }
}