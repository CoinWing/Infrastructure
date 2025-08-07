#!/bin/bash

# 시스템 업데이트
yum update -y

# AWS CLI v2 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip

# kubectl 설치
curl -LO "https://dl.k8s.io/release/v1.32.3/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/

cat << 'EOF' >> /root/.bashrc
alias k=kubectl
export PATH=/usr/local/aws-cli/v2/current/bin:$PATH
EOF

source /root/.bashrc