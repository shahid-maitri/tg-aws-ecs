include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "vpc_common" {
  # path   = "${get_repo_root()}/_envcommon/vpc.hcl"  # Use with GIT INIT only
  path   = find_in_parent_folders("_envcommon/vpc.hcl")
  expose = true
}

inputs = {
  vpc_cidr  = "10.0.0.0/16"
}