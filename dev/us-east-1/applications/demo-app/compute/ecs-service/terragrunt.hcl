include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "ecs_service_common" {
  path = find_in_parent_folders("_envcommon/ecs_service.hcl")
  expose = true
}

# 🔗 ECS Cluster dependency
dependency "ecs_cluster" {
  config_path = "../../base-infra/ecs-cluster"

  mock_outputs = {
    arn = "arn:aws:ecs:region:account:cluster/mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# 🔗 VPC dependency
dependency "vpc" {
  config_path = "../../base-infra/vpc"

  mock_outputs = {
    public_subnets = ["subnet-00000000"]
    vpc_id         = "vpc-00000000"
    vpc_cidr_block = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# (Optional but clean)
# 🔗 ECR dependency
dependency "ecr" {
  config_path = "../../shared/ecr"

  mock_outputs = {
    repository_url = "mock.dkr.ecr"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}




inputs = {
  aws_region          = include.ecs_service_common.locals.region
  environment         = include.ecs_service_common.locals.environment
  app                 = include.ecs_service_common.locals.app
  profile             = include.ecs_service_common.locals.profile

  # 🔗 Cluster
  ecs_cluster_arn     = dependency.ecs_cluster.outputs.arn

  # 🔗 Networking
  public_subnet_ids   = dependency.vpc.outputs.public_subnets
  vpc_id              = dependency.vpc.outputs.vpc_id

  # 🔗 Service config
  ecs_service = {
    name              = "${include.ecs_service_common.locals.environment}-${include.ecs_service_common.locals.app}-service"
    desired_count     = 1
    launch_type       = "FARGATE"
  }

  # 🔗 Task config
  ecs_task = {
    family                   = "${include.ecs_service_common.locals.environment}-${include.ecs_service_common.locals.app}-task"
    container_name           = "sk-flask-container"
    container_image          = "${dependency.ecr.outputs.repository_url}:latest"
    container_image_port     = 5000
    cpu                      = 256
    memory                   = 512
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    log_group_name           = "/ecs/${include.ecs_service_common.locals.app}"
  }

  public_ip = true

  load_balancer = {
    internal            = false
    load_balancer_type  = "application"
    health_check_path   = "/health"
  }

  tags = {
    ManagedBy = "Terragrunt"
  }
}







