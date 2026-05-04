# create ecs_task definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                = var.ecs_task.family
  container_definitions = jsonencode([{
    name                = var.ecs_task.container_name
    image               = var.ecs_task.container_image
    essential           = true
    portMappings = [{
      containerPort     = var.ecs_task.container_image_port
      hostPort          = var.ecs_task.container_image_port
      protocol          = "tcp"
    }]
    # environmentFiles = [{
    #   value = aws_s3_object.env_file.arn
    #   type = "s3"
    # }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
        "mode"                  = "non-blocking"
        "max-buffer-size"       = "25m"
      }
    }
  }])
  # 256 CPU = 0.25 vCPU
  cpu                       = var.ecs_task.cpu
  memory                    = var.ecs_task.memory
  requires_compatibilities  = var.ecs_task.requires_compatibilities
  network_mode              = var.ecs_task.network_mode
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
  #task_role_arn             = aws_iam_role.ecs_task_role.arn
}




# create ecs service
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service.name
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.ecs_service.desired_count
  launch_type     = var.ecs_service.launch_type

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.public_ip
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.app_tg.arn
  #   container_name   = var.ecs_task.container_name
  #   container_port   = var.ecs_task.container_image_port
  # }

  tags = merge(
    {
      Environment = var.environment
      Application = var.app
      Service     = "api"
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  # Create the ALB listener BEFORE creating the ECS service
  # depends_on = [aws_lb_listener.app_http_listener]
}

############################################
# CloudWatch Log Group (pre-created)
############################################
resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.ecs_task.log_group_name
  retention_in_days = 7
}