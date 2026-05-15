variable "aws_region" {
    type    = string
    default = "ap-northeast-1"
}

variable "project_name" {
    type    = string
}

variable "domain_name" {
    type    = string
}

variable "personal_email" {
  type        = string
  sensitive   = true
}