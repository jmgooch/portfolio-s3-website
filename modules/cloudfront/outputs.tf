output "cloudfront_arn" {
  value       = aws_cloudfront_distribution.site.arn
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.site.hosted_zone_id
}