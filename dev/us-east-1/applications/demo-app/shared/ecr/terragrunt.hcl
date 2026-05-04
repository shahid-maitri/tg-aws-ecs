include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ecr_common" {
  path   = find_in_parent_folders("_envcommon/ecr.hcl")
  expose = true
}

inputs = { 
  force_delete         = true # Set to true only for dev/test environments
  
  # Lifecycle policy settings
  enable_lifecycle_policy = true
  max_image_count        = 10 # Keep last 10 images
}