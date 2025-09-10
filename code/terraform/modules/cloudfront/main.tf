# S3 bucket for CloudFront static content
resource "aws_s3_bucket" "cloudfront_bucket" {
  bucket = "${var.project_name}-${var.env}-cloudfront-static"

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudfront-static"
    Environment = var.env
    Project     = var.project_name
  }
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "cloudfront_bucket" {
  bucket = aws_s3_bucket.cloudfront_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_bucket" {
  bucket = aws_s3_bucket.cloudfront_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "cloudfront_bucket" {
  bucket = aws_s3_bucket.cloudfront_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-${var.env}-oac"
  description                       = "OAC for ${var.project_name}-${var.env}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "distribution" {
  # S3 Origin
  origin {
    domain_name              = aws_s3_bucket.cloudfront_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3-${aws_s3_bucket.cloudfront_bucket.bucket}"
  }

  # ALB Origin (for API)
  dynamic "origin" {
    for_each = var.alb_domain_name != null ? [1] : []
    content {
      domain_name = var.alb_domain_name
      origin_id   = "ALB-${var.project_name}-${var.env}"
      
      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name}-${var.env} CloudFront Distribution"
  default_root_object = var.default_root_object

  # Aliases (custom domain names)
  aliases = var.domain_aliases

  # Default cache behavior (for static content from S3)
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.cloudfront_bucket.bucket}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = var.cache_min_ttl
    default_ttl = var.cache_default_ttl
    max_ttl     = var.cache_max_ttl
  }

  # Cache behavior for API requests
  dynamic "ordered_cache_behavior" {
    for_each = var.alb_domain_name != null ? [1] : []
    content {
      path_pattern           = "/api/*"
      allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "ALB-${var.project_name}-${var.env}"
      compress               = true
      viewer_protocol_policy = "redirect-to-https"

      forwarded_values {
        query_string = true
        headers      = ["*"]
        cookies {
          forward = "all"
        }
      }

      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0
    }
  }

  # Price class
  price_class = var.price_class

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # SSL Certificate
  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == null ? true : false
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = var.certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.certificate_arn != null ? "TLSv1.2_2021" : null
  }

  # Custom error responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  # Logging configuration
  dynamic "logging_config" {
    for_each = var.logging_bucket != null ? [1] : []
    content {
      include_cookies = false
      bucket          = var.logging_bucket
      prefix          = var.logging_prefix
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudfront"
    Environment = var.env
    Project     = var.project_name
  }
}

# S3 bucket policy for CloudFront OAC
resource "aws_s3_bucket_policy" "cloudfront_bucket_policy" {
  bucket = aws_s3_bucket.cloudfront_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.cloudfront_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.distribution.arn
          }
        }
      }
    ]
  })
}

# Route53 record for CloudFront (if domain is provided)
resource "aws_route53_record" "cloudfront_record" {
  count   = var.create_route53_record && var.route53_zone_id != null ? length(var.domain_aliases) : 0
  zone_id = var.route53_zone_id
  name    = var.domain_aliases[count.index]
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

