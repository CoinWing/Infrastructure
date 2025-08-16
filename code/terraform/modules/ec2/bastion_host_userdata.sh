#!/bin/bash

# 시스템 업데이트
yum update -y

# Git 설치
yum install git -y
git clone https://github.com/CoinWing/Infrastructure.git

# AWS CLI v2 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip

# kubectl 설치
curl -LO "https://dl.k8s.io/release/v1.32.3/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/

# helm 설치
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -rf get_helm.sh

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
rm -rf /tmp/eksctl

# .bashrc 설정
cat << 'EOF' >> /root/.bashrc
alias k=kubectl
alias eks_provisioning=/usr/local/provisioning_eks_cluster.sh
export PATH=/usr/local/bin:/usr/local/aws-cli/v2/current/bin:$PWD/bin:$PATH
EOF

source /root/.bashrc

### Provisioning EKS Cluster Script Add ###
### 필독! ###
# 프로비저닝 스크립트는 아래 명령어를 통해 터미널에서 권한을 얻은 후 실행해야 합니다.
# 해당 부분은 EKS 클러스터가 재생성되는 경우가 많으므로 자동화 하지 않았습니다.
# 실행 전 주의사항 : 클러스터 삭제 후 삭제되지 않은 ALB 리소스 수동 삭제 필수
# 프로비저닝 스크립트 실행 방법 : eks_provisioning 리전명 클러스터명
# 예시) eks_provisioning ap-northeast-1 cowing-dev-eks
cat << 'EOF' >> /usr/local/provisioning_eks_cluster.sh
# 클러스터 인증 정보 업데이트
aws eks update-kubeconfig --region $1 --name $2
kubectl create namespace cowing-prod

# Istio 설치
kubectl create namespace istio-system
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=default -y
kubectl label namespace cowing-prod istio-injection=enabled

# Istio Ingress Gateway Serivce -> NodePort 변경
kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec":{"type":"NodePort"}}'

# EKS 내부에 IAM Service Account 생성
eksctl delete iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace kube-system \
  --name aws-load-balancer-controller \

sleep 45 # 45초 대기

eksctl create iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::593793025731:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts

# IAM OIDC Provider 연동
eksctl utils associate-iam-oidc-provider \
  --region $1 \
  --cluster $2 \
  --approve

# cert-manager 설치
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

# ALB Ingress Controller 설치
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$2 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
EOF

# TODO
# cert-arn.txt 적용 부분 자동화 필요
# 클러스터 삭제 후 삭제되지 않은 ALB 리소스 수동 삭제 필수
# ALB 생성 후 Route53 레코드 업데이트를 위해 Terraform apply 실행 필수
# Route53 레코드 업데이트 후 NS 레코드 변경되는 경우 있으니, 가비아에서 확인 필수
chmod +x /usr/local/provisioning_eks_cluster.sh

# 테스트용 코드
# kubectl exec -it msa-front-podId -n cowing-prod -- wget -qO- http://localhost:3000/ | head -20
# kubectl exec -it test-pod -n cowing-prod -- curl http://msa-front:3000/
# kubectl exec -it test-pod -n cowing-prod -- curl -s -H "Host: cowing.co.kr" http://msa-front:3000/
# kubectl exec -it test-pod -n cowing-prod -- curl -s -H "Host: cowing.co.kr" http://istio-ingressgateway.istio-system.svc.cluster.local/
# curl -s -H "Host: cowing.co.kr" http://k8s-istiosys-albingre-31ac82b7d4-1550880697.ap-northeast-2.elb.amazonaws.com
# curl -s -H "Host: cowing.co.kr" https://k8s-istiosys-albingre-31ac82b7d4-1550880697.ap-northeast-2.elb.amazonaws.com
# curl -s -H "Host: cowing.co.kr" https://cowing.co.kr