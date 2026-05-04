data "aws_caller_identity" "current" {}


## They fetch existing KMS keys using alias names.
## ECS task needs permissions to use those keys if the S3 buckets are encrypted with KMS.:


# data "aws_kms_key" "input-bucket-kms-key" {
#   key_id = "alias/${var.input-bucket}-s3-bucket-key-kms"
# }

# data "aws_kms_key" "workspace-bucket-kms-key" {
#   key_id = "alias/${var.workspace-bucket}-s3-bucket-key-kms"
# }




# create ecs_task_execution_role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.environment}-${var.app}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# # Allow ECS task to create and write to CloudWatch Logs
# resource "aws_iam_role_policy" "ecs_task_execution_logs_policy" {
#   name = "${var.environment}-${var.app}-ecs-task-execution-logs"
#   role = aws_iam_role.ecs_task_execution_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "arn:aws:logs:*:*:*"
#       }
#     ]
#   })
# }

