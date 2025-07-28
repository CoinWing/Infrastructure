#!/bin/bash

SA_NAME="kiali"  # 서비스 어카운트 이름
NAMESPACE="istio-system"           # 네임스페이스

TOKEN=$(kubectl create token $SA_NAME -n $NAMESPACE --duration=24h)

if [ -n "$TOKEN" ]; then
    echo "생성된 Kubernetes 토큰: $TOKEN"
else
    echo "토큰 생성에 실패했습니다. kubectl 설정을 확인하세요."
fi

WH_URL="${DISCORD_WEBHOOK_URL}"
EMOJI="👍"
COLOR=3066993

# Discord 메시지 전송
curl -H "Content-Type: application/json" -X POST "$WH_URL" -d '{
    "content": "느낌 좋은 토큰 배달이요",
    "embeds": [
        {
            "title": "'"$EMOJI"' 토큰 생성됨",
            "color": '"$COLOR"',
            "fields": [
                {
                    "name": "Token",
                    "value": "'"$TOKEN"'",
                    "inline": true
                }
            ],
            "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
        }
    ]
}'
~                         