resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = merge(
    {
      Environment = var.environment
      Application = var.app
      Service     = "ecs-cluster"
    },
    var.tags
  )
}