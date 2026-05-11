output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}

output "route53_name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "zone_id" {
  value = aws_route53_zone.main.zone_id
}