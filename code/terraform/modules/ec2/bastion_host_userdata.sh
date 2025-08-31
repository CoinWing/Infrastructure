#!/bin/bash

# 시스템 업데이트
yum update -y

# Git 설치
yum install git -y
git clone https://github.com/CoinWing/Infrastructure.git

# AWS CLI v2 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
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

# Ansible 설치
yum install epel-release -y
yum install python3 python3-pip -y
yum install ansible -y
pip3 install kubernetes boto3 botocore openshift
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.aws

# .bashrc 설정
cat << 'EOF' >> /root/.bashrc
alias k=kubectl
alias eks_provisioning=/usr/local/provisioning_eks_cluster.sh
alias eks_kube_system_provisioning=/usr/local/provisioning_kube_resources_without_argocd.sh
alias eks_argocd_provisioning=/usr/local/provisioning_argocd.sh
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
cat << 'EOF' > /usr/local/provisioning_eks_cluster.sh
# 클러스터 인증 정보 업데이트
aws eks update-kubeconfig --region $1 --name $2 && sleep 10
kubectl create namespace cowing-prod
kubectl create namespace external-secrets-system
kubectl create namespace istio-system

# Istio 설치
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=default -y
kubectl label namespace cowing-prod istio-injection=enabled

# Istio Ingress Gateway Serivce -> NodePort 변경
kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec":{"type":"NodePort"}}'

# IAM OIDC Provider 연동
eksctl utils associate-iam-oidc-provider \
  --region $1 \
  --cluster $2 \
  --approve && sleep 10

# EKS 내부에 IAM Roles for Service Accounts(IRSAs) 생성
eksctl delete iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace kube-system \
  --name aws-load-balancer-controller && sleep 30

eksctl create iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::593793025731:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve && sleep 30

eksctl delete iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace kube-system \
  --name external-secrets && sleep 30

eksctl create iamserviceaccount \
  --region $1 \
  --cluster $2 \
  --namespace external-secrets-system \
  --name external-secrets \
  --attach-policy-arn arn:aws:iam::593793025731:policy/ExternalSecretPolicy \
  --override-existing-serviceaccounts \
  --approve && sleep 30

# cert-manager 설치
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

# ALB Ingress Controller 설치
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm uninstall aws-load-balancer-controller -n kube-system && sleep 30
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$2 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller && sleep 10

# ALB Ingress Controller 생성
sleep 30 && kubectl apply -f /root/Infrastructure/code/kubernetes/istio/alb-ingress-prod.yaml

# External Secrets 설치
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm uninstall external-secrets -n external-secrets-system && sleep 30
helm install external-secrets external-secrets/external-secrets \
  -n external-secrets-system \
  --set serviceAccount.create=false \
  --set serviceAccount.name=external-secrets

# External Secret 생성
kubectl apply -f /root/Infrastructure/code/kubernetes/external-secrets/cluster-secret-store.yaml
EOF

# 클러스터 삭제 후 삭제되지 않은 ALB 리소스 수동 삭제 필수
# ALB 생성 후 Route53 레코드 업데이트를 위해 Terraform apply 실행 필수
# Route53 Zone 재생성 후 NS 레코드 변경되는 경우 있으니, 가비아에서 확인 필수
chmod +x /usr/local/provisioning_eks_cluster.sh

cat << 'EOF' > /usr/local/provisioning_kube_resources_without_argocd.sh
kubectl apply -f /root/Infrastructure/code/kubernetes/common-service/mariadb-service-prod.yaml

kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/api-prod.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/front-prod.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/ws-prod.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/grafana-prod.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/kiali-prod.yaml

kubectl apply -f /root/Infrastructure/code/kubernetes/istio/istio-ingressgateway/gateway-prod.yaml

kubectl apply -f /root/Infrastructure/code/kubernetes/istio/grafana/dashboard.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/kiali/dashboard.yaml
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/prometheus/metric-server.yaml
EOF

chmod +x /usr/local/provisioning_kube_resources_without_argocd.sh

cat << 'EOF' > /root/apps.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apps
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/CoinWing/Infrastructure.git
    path: code/argocd/applications
    targetRevision: prod
    directory:
      recurse: true
  destination:
    server: https://kubernetes.default.svc
    namespace: cowing-prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

cat << 'EOF' > /usr/local/provisioning_argocd.sh
kubectl create namespace argocd
kubectl apply -f /root/Infrastructure/code/kubernetes/istio/virtualservices/argocd-prod.yaml
kubectl label namespace argocd istio-injection=enabled
curl -L -o argocd.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sed -i '/- \/usr\/local\/bin\/argocd-server/a\        - --insecure' argocd.yaml
kubectl apply -n argocd -f argocd.yaml
sleep 100
kubectl apply -n argocd -f /root/apps.yaml
EOF

chmod +x /usr/local/provisioning_argocd.sh


# 테스트용 코드
# kubectl exec -it msa-front-podId -n cowing-prod -- wget -qO- http://localhost:3000/ | head -20
# kubectl exec -it test-pod -n cowing-prod -- curl http://msa-front:3000/
# kubectl exec -it test-pod -n cowing-prod -- curl -s -H "Host: cowing.co.kr" http://msa-front:3000/
# kubectl exec -it test-pod -n cowing-prod -- curl -s -H "Host: cowing.co.kr" http://istio-ingressgateway.istio-system.svc.cluster.local/
# curl -s -H "Host: cowing.co.kr" http://k8s-istiosys-albingre-31ac82b7d4-1550880697.ap-northeast-2.elb.amazonaws.com
# curl -s -H "Host: cowing.co.kr" https://k8s-istiosys-albingre-31ac82b7d4-1550880697.ap-northeast-2.elb.amazonaws.com
# curl -s -H "Host: cowing.co.kr" https://cowing.co.kr