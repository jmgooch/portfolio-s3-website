resource "aws_s3_bucket" "main" {
    bucket_prefix = var.project_name

    tags = {
        Name = "S3 Website Bucket"
    }
}

resource "aws_s3_bucket_policy" "policy" {
    bucket = aws_s3_bucket.main.id
    policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn] 
    }
  }
}

locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".svg"  = "image/svg+xml"
  }
}

resource "aws_s3_object" "site_files" {
  for_each = fileset("${path.root}/site", "**/*")

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "${path.root}/site/${each.value}"

  source_hash = filemd5("${path.root}/site/${each.value}")

  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}