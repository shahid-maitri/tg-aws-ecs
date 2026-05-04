###############
# IAM Role    #
###############

resource "aws_iam_role" "this" {
  name = "${var.environment}-${var.app}-${var.instance_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.environment}-${var.app}-${var.instance_name}-ec2-role"
  }
}

###############
# SSM Access  #
###############

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

###############
# ECR Access  #
###############

resource "aws_iam_policy" "ecr_read" {
  name        = "${var.environment}-${var.app}-${var.instance_name}-ecr-read"
  description = "Allow ECR pull access for ${var.instance_name} EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "ECRPull"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ecr_read.arn
}

######################
# Instance Profile   #
######################

resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-${var.app}-${var.instance_name}-ec2-profile"
  role = aws_iam_role.this.name
}