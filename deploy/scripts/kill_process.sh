#!/bin/bash

# 기존에 실행 중인 Pod 중지 (삭제)
POD_NAME="opbookshop"
NAMESPACE="bookshop"  # 네임스페이스를 'bookshop'으로 설정

echo "Stopping and removing existing Pod in the bookshop namespace..."
kubectl delete pod ${POD_NAME} -n ${NAMESPACE} --ignore-not-found=true

# 이전 이미지를 삭제하려는 경우 - 일반적으로 Kubernetes에서는 필요하지 않지만, 로컬 환경에서는 고려 가능
echo "Removing old Docker image..."
if docker images | grep -q "kimaudwns/opbookshop:latest"; then
    docker rmi kimaudwns/opbookshop:latest || true
    echo "Docker image kimaudwns/opbookshop:latest removed successfully."
else
    echo "No old image found to remove."
fi

# 새로운 Pod 생성 (이미지 업데이트 시 배포 파일을 수정하여 적용)
echo "Starting new deployment in the bookshop namespace..."
kubectl apply -f /home/ubuntu/deploy/scripts/opbookshop-pod.yml -n ${NAMESPACE}
