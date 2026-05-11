module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cloudfront" {
  source            = "./modules/cloudfront"
  project_name      = var.project_name
  domain_name           = var.domain_name
  certificate_arn       = module.dns.certificate_arn
  s3_bucket_domain_name = module.s3.bucket_regional_domain_name
  oac_id                = module.s3.oac_id
}