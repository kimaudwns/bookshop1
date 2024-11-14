#!/bin/bash

# 현재 실행 중인 Docker 컨테이너 종료
echo "Stopping and removing existing container..."
docker stop opbookshop || true
docker rm opbookshop || true

# 현재 실행 중인 이미지 삭제
echo "Removing old Docker image..."
if docker images | grep -q "kimaudwns/opbookshop:latest"; then
    docker rmi kimaudwns/opbookshop:latest || true
    echo "Docker image kimaudwns/opbookshop:latest removed successfully."
else
    echo "No old image found to remove."
fi

# 새로운 이미지 빌드 및 실행
echo "Starting new deployment..."
docker-compose -f /home/ubuntu/deploy/scripts/docker-compose.yml up -d --build
