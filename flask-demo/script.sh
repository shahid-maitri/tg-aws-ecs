#!/bin/bash
set -e

# ── Config ──────────────────────────────────────────────────────────────
AWS_REGION=""

ECR_REPO=""
AWS_PROFILE=""

IMAGE_NAME=""
IMAGE_TAG="latest"

ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"


# Auto-fetch account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account --output text --profile ${AWS_PROFILE})

# ── Build ────────────────────────────────────────────────────────────────
echo ">>> Building Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# ── Auth ─────────────────────────────────────────────────────────────────
echo ">>> Authenticating with ECR..."
aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} \
  | docker login --username AWS --password-stdin ${ECR_URI}

# ── Tag ──────────────────────────────────────────────────────────────────
echo ">>> Tagging image..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}

# ── Push ─────────────────────────────────────────────────────────────────
echo ">>> Pushing to ECR..."
docker push ${ECR_URI}:${IMAGE_TAG}

echo ""
echo "✅ Done! Image pushed to:"
echo "   ${ECR_URI}:${IMAGE_TAG}"