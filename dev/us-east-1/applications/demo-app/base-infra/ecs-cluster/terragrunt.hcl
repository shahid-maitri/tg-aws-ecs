include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ecs_cluster_common" {
  path = find_in_parent_folders("_envcommon/ecs_cluster.hcl")
  expose = true
}


inputs = {
  name        = "${include.ecs_cluster_common.locals.environment}-${include.ecs_cluster_common.locals.app}-cluster"
  environment = include.ecs_cluster_common.locals.environment
  app         = include.ecs_cluster_common.locals.app
  tags = {
    Environment = include.ecs_cluster_common.locals.environment
    App         = include.ecs_cluster_common.locals.app
  }
}
