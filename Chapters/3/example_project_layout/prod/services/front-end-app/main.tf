terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.58.0"
    }
  }
  backend "s3" {
    #rest of the config is stored in backend.hcl see file for how to run init.
    key = "global/s3/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}