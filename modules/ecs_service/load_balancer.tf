# Create Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-${var.app}-security-group"
  description = "Allow http and https access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app}-lb-security-group"
  }
}


# Create Application/Network Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.environment}-${var.app}-lb"
  internal           = var.load_balancer.internal
  load_balancer_type = var.load_balancer.load_balancer_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-${var.app}-lb"
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.environment}-${var.app}-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip" # important for Fargate tasks
  vpc_id      = var.vpc_id

  deregistration_delay = 30 # Faster destroy in dev

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = var.load_balancer.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

# Create ALB Listener
resource "aws_lb_listener" "app_http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
