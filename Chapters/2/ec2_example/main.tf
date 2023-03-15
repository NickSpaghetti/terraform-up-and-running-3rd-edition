terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "instance" {
  name = "nc-terraform-example"
  ingress {
    from_port   = var.server_port
    protocol    = "tcp"
    to_port     = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name   = "nc-security-group"
    Source = "terraform-up-and-running-3rd-edition"
  }
}

resource "aws_instance" "example_ec2" {
  ami                         = "ami-0fd2c44049dd805b8"
  instance_type               = "t2.micro"
  user_data_replace_on_change = true
  user_data                   = <<EOF
              #!/bin/bash
              echo "Hello, World > index.html
              nohup busybox httpd -f -p 8080 &
  EOF
  vpc_security_group_ids      = [aws_security_group.instance.id]
  tags = {
    Name   = "nc-ec2-example"
    Source = "terraform-up-and-running-3rd-edition"
  }
}