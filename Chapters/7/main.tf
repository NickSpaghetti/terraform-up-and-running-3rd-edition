provider "aws" {
  region = "us-east-1"
  alias = "region_use_1"
}

provider "aws" {
  region = "us-east-2"
  alias = "region_use_2"
}

data "aws_region" "region_use_1" {
  provider = aws.region_use_1
}
data "aws_region" "region_use_2" {
  provider = aws.region_use_2
}

resource "aws_instance" "region_1" {
  provider = aws.region_use_1

  ami = "ami-01f87c43e618bf8f0"
  instance_type = "t2.mirco"
}

resource "aws_instance" "region_2" {
  provider = aws.region_use_2

  ami = "ami-0fb65ca2d3203ac1"
  instance_type = "t2.mirco"
}

