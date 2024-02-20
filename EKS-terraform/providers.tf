
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}
provider "aws" {
  region     = var.aws_region
  shared_credentials_files = var.awscli_cred_dict
  profile                 = "default"
}
