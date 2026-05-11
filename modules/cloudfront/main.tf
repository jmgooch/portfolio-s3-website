resource "aws_cloudfront_distribution" "site" {
  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = var.oac_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
      headers      = ["Accept-Language"]
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.language_routing.arn
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }
}

resource "aws_cloudfront_function" "language_routing" {
  name    = "${var.project_name}-language-routing"
  runtime = "cloudfront-js-1.0"
  comment = "Routes root traffic to /en or /jp based on browser language"
  publish = true
  code    = file("${path.module}/routing.js")
}