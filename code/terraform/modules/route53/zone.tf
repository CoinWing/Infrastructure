## 주의 : public zone 생성 수 Third-Party Domain 제공 업체에 Name Server 정보 변경 필수
# 연동 후 AWS Console 에서 Test Record 진행 후 정상 동작 확인 필수
resource "aws_route53_zone" "cowing_co_kr_zone" {
  name = "cowing.co.kr"
}