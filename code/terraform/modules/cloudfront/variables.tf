variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "domain_aliases" {
  type        = list(string)
  description = "List of domain aliases for CloudFront distribution"
  default     = []
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate for HTTPS"
  default     = null
}

variable "default_root_object" {
  type        = string
  description = "Default root object for CloudFront"
  default     = "index.html"
}

variable "price_class" {
  type        = string
  description = "CloudFront price class"
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "geo_restriction_type" {
  type        = string
  description = "Geo restriction type (none, whitelist, blacklist)"
  default     = "none"
  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction_type)
    error_message = "Geo restriction type must be one of: none, whitelist, blacklist."
  }
}

variable "geo_restriction_locations" {
  type        = list(string)
  description = "List of country codes for geo restriction"
  default     = []
}

variable "cache_min_ttl" {
  type        = number
  description = "Minimum TTL for cache"
  default     = 0
}

variable "cache_default_ttl" {
  type        = number
  description = "Default TTL for cache"
  default     = 3600
}

variable "cache_max_ttl" {
  type        = number
  description = "Maximum TTL for cache"
  default     = 86400
}

variable "custom_error_responses" {
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  description = "List of custom error responses"
  default = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
}

variable "logging_bucket" {
  type        = string
  description = "S3 bucket for CloudFront access logs"
  default     = null
}

variable "logging_prefix" {
  type        = string
  description = "Prefix for CloudFront access logs"
  default     = "cloudfront-logs/"
}

variable "alb_domain_name" {
  type        = string
  description = "ALB domain name for API requests"
  default     = null
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
  default     = null
}

variable "create_route53_record" {
  type        = bool
  description = "Whether to create Route53 record for CloudFront"
  default     = true
}