locals {
  # Load configs
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars = try(read_terragrunt_config(find_in_parent_folders("region.hcl")), null)
  app_vars    = try(read_terragrunt_config(find_in_parent_folders("app.hcl")), null)

  # Extract values (SAFE: fallback defaults added)
  environment = local.environment_vars.locals.environment
  aws_region  = local.region_vars.locals.aws_region
  app         = local.app_vars.locals.app_name
 

  # Optional but recommended (define in env.hcl later)
  account_id = try(local.environment_vars.locals.aws_account_id, "")
  profile    = try(local.environment_vars.locals.profile, "default")

  # Backend naming (clean + consistent)
  #backend_bucket_name  = "${local.app}-${local.environment}-${local.aws_region}-tf-state-bucket"
  #backend_dynamodb_table = "${local.app}-${local.environment}-tf-lock-table"

  # Infra account profile (for remote state)
  infra_profile = "karim"
  state_file_profile = get_env("TF_VAR_state_file_profile", local.infra_profile)

  # Provider versions
  provider_aws_version = "~> 6.0"
  
  # # NEW: Detect if we're in bootstrap
  # is_bootstrap         = strcontains(get_terragrunt_dir(), "remote-state")
}

# =========================
# Provider (AWS)
# =========================
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.provider_aws_version}"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.42"
    }
  }
}

provider "aws" {
  region  = "${local.aws_region}"
  profile = "${local.profile}"
  ${local.account_id != "" ? "allowed_account_ids = [\"${local.account_id}\"]" : ""}
}
EOF
}

# =========================
# AWS Cloud Control Provider
# =========================
# generate "awscc_provider" {
#   path      = "awscc_provider.tf"
#   if_exists = "overwrite_terragrunt"

#   contents = <<EOF
# provider "awscc" {
#   region  = "${local.aws_region}"
#   profile = "${local.profile}"
# }
# EOF
# }

# =========================
# Remote State (S3 + DynamoDB)
# =========================
# remote_state {
#   backend = "s3"

#   config = {
#     encrypt        = true
#     bucket         = local.backend_bucket_name
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = local.aws_region
#     profile        = local.state_file_profile
#     #dynamodb_table = local.backend_dynamodb_table
#     use_lockfile = true  # ✅ Native S3 locking — no DynamoDB!
#   }

#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }



# =========================
# Shared Inputs (DRY)
# =========================
inputs = merge(
  local.environment_vars.locals,
  local.region_vars != null ? local.region_vars.locals : {},
  local.app_vars != null ? local.app_vars.locals : {}
)