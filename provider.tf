terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-file-bucket-zx9v"
    key          = "terraform-portfolio-s3-website.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

#provider for the ACM certificate to be in us-east-1 for Cloudfront
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}