#!/bin/bash

# 设置变量
DOCKER_USERNAME="starkwang"
IMAGE_NAME="zgi-fe-base"
VERSION="1.0.2"

# 删除现有的构建器实例
echo "Removing existing buildx instance..."
docker buildx rm mybuilder || true

# 设置 buildx
echo "Setting up buildx..."
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap

# 构建镜像
echo "Building Docker image..."
docker buildx build \
  --platform=linux/amd64 \
  --output type=docker \
  -t ${IMAGE_NAME}:${VERSION} \
  -f Docker.base .

# 给镜像打标签
echo "Tagging image..."
docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

# 登录 Docker Hub
echo "Logging in to Docker Hub..."
docker login

# 推送镜像到 Docker Hub
echo "Pushing image to Docker Hub..."
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

# 清理
echo "Cleaning up..."
docker buildx rm mybuilder

echo "Done!" 