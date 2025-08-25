resource "aws_route53_record" "cowing_co_kr_apex_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_www_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_api_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_grafana_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "grafana.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_kiali_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "kiali.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_ws_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "ws.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cowing_co_kr_argocd_a" {
  zone_id = var.cowing_co_kr_zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
