## 주의 : public zone 생성 수 Third-Party Domain 제공 업체에 Name Server 정보 변경 필수
# 연동 후 AWS Console 에서 Test Record 진행 후 정상 동작 확인 필수
resource "aws_route53_zone" "cowing_co_kr_zone" {
  name = "cowing.co.kr"
}

resource "aws_route53_record" "cowing_co_kr_apex_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "cowing.co.kr"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_www_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "www.cowing.co.kr"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_grafana_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "grafana.cowing.co.kr"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_kiali_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "kiali.cowing.co.kr"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_ws_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "ws.cowing.co.kr"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
