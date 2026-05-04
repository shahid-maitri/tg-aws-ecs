# create security group for ecs service
resource "aws_security_group" "ecs_sg" {
  name        = "${var.environment}-${var.app}-ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ecs_task.container_image_port
    to_port     = var.ecs_task.container_image_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}