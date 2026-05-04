include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "s3_common" {
  path   = find_in_parent_folders("_envcommon/s3.hcl")
  expose = true
}


inputs = {
  bucket_name = "${include.s3_common.locals.environment}-${include.s3_common.locals.app}-bucket"

  tags = {
    App         = include.s3_common.locals.app
    Environment = include.s3_common.locals.environment
  }
}
