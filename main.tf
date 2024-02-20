# ------------------------------
# Terraform configuration
# ------------------------------

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "mst-t-tfstate-bucket-mst-t"
    key     = "mst-t-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform_practice"
  }
}

# module "webserver" {
#   source        = "./modules/nginx_server"
#   instance_type = "t2.micro"
# }

# output "web_server_id" {
#   value = module.webserver.instance_id
# }


# ------------------------------
# Provider
# ------------------------------

provider "aws" {
  region  = "ap-northeast-1"
  profile = "terraform_practice"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "terraform_practice"
}

# ------------------------------
# Variables
# ------------------------------

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
}