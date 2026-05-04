# Flask ECS Fargate — Terragrunt

Deploy a Flask app to AWS ECS Fargate using Terragrunt.

---

## What This Does

- Creates a VPC with a public subnet
- Pushes a Flask Docker image to ECR
- Runs it as a Fargate task on ECS
- Provisions an EC2 ops host (SSM access, no public SSH)
- Sends container logs to CloudWatch
- Exposes the app via an Application Load Balancer (ALB) on port 80

