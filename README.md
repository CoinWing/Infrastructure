# Cowing Infrastructure

이 저장소는 Cowing 암호화폐 거래 플랫폼의 인프라 구성을 관리합니다.   
Docker Compose를 통한 로컬 개발 환경과 EKS를 통한 프로덕션 배포 환경을 지원하고 있습니다.

## 🏗️ 아키텍처 개요

Cowing은 마이크로서비스 아키텍처(Microservice Architecture)로 구성되어 있으며, 다음과 같은 서비스들로 구성됩니다:

- **Frontend Service**: Next.js 기반 웹 애플리케이션
- **Auth Service**: 사용자 인증 및 권한 관리
- **Trading Service**: 거래 주문 처리 및 매칭 엔진
- **Orderbook Service**: 매칭 엔진을 위한 실시간 호가 데이터 제공
- **Broadcaster Service**: WebSocket을 통한 실시간 데이터 브로드캐스팅
- **Database**: MariaDB (메인 데이터베이스)
- **Cache**: Redis (세션 및 캐시 저장소)

## 🐳 Docker Compose (로컬 개발 환경)

### 서비스 포트 매핑

| 서비스 | 포트 | 설명 |
|--------|------|------|
| **Nginx Proxy** | `80` | 리버스 프록시 및 로드 밸런서 |
| **Frontend** | `3000` | Next.js 웹 애플리케이션 |
| **MariaDB** | `3306` | 메인 데이터베이스 |
| **Redis** | `6379` | 캐시 및 세션 저장소 |
| **Auth Service** | `8080` | 인증 및 사용자 관리 API |
| **Trading Service** | `8081` | 거래 주문 처리 API |
| **Orderbook Service** | `8082` | 거래 주문 처리를 위한 실시간 호가 데이터 API |
| **Broadcaster Service** | `8083` | WebSocket 실시간 데이터 |

## ☸️ EKS (프로덕션 환경)

### 네임스페이스

- `cowing-prod`: 프로덕션 환경
- `cowing-staging`: 스테이징 환경

### 서비스 포트 매핑 (프로덕션)

| 서비스 | 포트 | 타입 | 설명 |
|--------|------|------|------|
| **msa-front** | `3000` | ClusterIP | 프론트엔드 서비스 |
| **common-mariadb** | `3306` | ExternalName | 외부 MariaDB |
| **msa-trade-redis** | `6379` | ClusterIP | 거래용 Redis |
| **msa-auth-redis** | `6380` | ClusterIP | 인증용 Redis |
| **msa-auth** | `8080` | ClusterIP | 인증 서비스 |
| **msa-orderbook** | `8081` | ClusterIP | 호가창 서비스 |
| **msa-trade** | `8082` | ClusterIP | 거래 서비스 |
| **msa-broadcaster** | `8083` | ClusterIP | 브로드캐스터 서비스 |


## 📁 디렉토리 구조

```
infrastructure/
├── code/
│   ├── docker/
│   │   ├── docker-compose.yaml    # 로컬 개발 환경
│   │   └── nginx/
│   │       └── nginx.conf         # Nginx 설정
│   └── kubernetes/                # 프로덕션 배포 환경 
│       ├── msa-auth/              # 인증 서비스 K8s 설정
│       ├── msa-trade/             # 거래 서비스 K8s 설정
│       ├── msa-orderbook/         # 호가창 서비스 K8s 설정
│       ├── msa-broadcaster/       # 브로드캐스터 서비스 K8s 설정
│       ├── msa-front/             # 프론트엔드 서비스 K8s 설정
│       ├── common-service/        # 공통 서비스 (DB)
│       ├── istio/                 # Istio 설정
│       ├── namespace/             # 네임스페이스 정의
│       └── secrets/               # 시크릿 설정 (예시)
└── design/                        # 아키텍처 설계 문서
    ├── project1.drawio
    ├── sprint1-serverless-architecture.drawio
    └── AWS-Architecture-Icon-Decks/
```