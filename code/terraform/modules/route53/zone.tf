## 주의 : public zone 생성 수 Third-Party Domain 제공 업체에 Name Server 정보 변경 필수
# 연동 후 AWS Console 에서 Test Record 진행 후 정상 동작 확인 필수
resource "aws_route53_zone" "cowing_co_kr_zone" {
  name = var.domain_name

  tags = {
    Name = "${var.project_name}-${var.env}-route53-zone-${var.domain_name}"
  }
}

resource "aws_route53_record" "cowing_co_kr_apex_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_www_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_api_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_grafana_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "grafana.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_kiali_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "kiali.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_ws_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "ws.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_argocd_a" {
  zone_id = aws_route53_zone.cowing_co_kr_zone.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
