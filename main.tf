module "s3" {
  source                    = "./modules/s3"
  project_name              = var.project_name
}

module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "cloudfront" {
  source            = "./modules/compute"
  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  certificate_arn   = module.dns.certificate_arn
  zone_id           = module.dns.zone_id
  domain_name       = var.domain_name
}