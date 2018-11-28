variable "static_site_bucket_name" {
  default = "otc-site"
}

variable "remote_state_bucket_name" {
  default = "otc-tf"
}

variable "remote_state_key_name" {
  default = "otc/terraform.tfstate"
}

variable "region" {
  default = "us-west-2"
}

variable "aws_access_key_id" {}

variable "aws_secret_access_key" {}