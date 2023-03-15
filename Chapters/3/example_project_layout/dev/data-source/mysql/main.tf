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
    key = "dev/data-stores/mysql/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "mysql" {
    identifier_prefix = "nc-terraform-up-and-running"
    allocated_storage    = 10
    db_name              = "nc-mydb"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    username             = var.db_usn
    password             = var.db_pwd
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
}