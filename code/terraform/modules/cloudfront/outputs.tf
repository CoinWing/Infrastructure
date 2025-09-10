output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.distribution.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.distribution.arn
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "distribution_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  value       = aws_cloudfront_distribution.distribution.hosted_zone_id
}

output "s3_bucket_name" {
  description = "S3 bucket name for static content"
  value       = aws_s3_bucket.cloudfront_bucket.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for static content"
  value       = aws_s3_bucket.cloudfront_bucket.arn
}

output "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.cloudfront_bucket.bucket_domain_name
}

output "origin_access_control_id" {
  description = "CloudFront Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.oac.id
}
