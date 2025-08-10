resource "aws_acm_certificate" "cowing_co_kr_cert" {
  domain_name       = "*.${var.domain_name}"
  subject_alternative_names = [var.domain_name]
  validation_method = "DNS"
}

resource "aws_route53_record" "cowing_co_kr_cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cowing_co_kr_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.cowing_co_kr_zone_id
}

resource "aws_acm_certificate_validation" "cowing_co_kr_cert_validation" {
  certificate_arn         = aws_acm_certificate.cowing_co_kr_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cowing_co_kr_cert_validation_records : record.fqdn]
}

# 인증서 ARN을 파일로 생성
resource "local_file" "k8s_cert_arn" {
  content  = aws_acm_certificate_validation.cowing_co_kr_cert_validation.certificate_arn
  filename = "${path.module}/../../../kubernetes/istio/cert-arn.txt"
  
  depends_on = [aws_acm_certificate_validation.cowing_co_kr_cert_validation]
}