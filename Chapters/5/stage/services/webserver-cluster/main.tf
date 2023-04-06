
provider "aws" {
  region = "us-east-1"
}

module "WebService-Cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "nc-terraform-by-example"
  remote_state_bucket = "nc-terraform-up-and-running-state"
  remote_state_key_path = "stage/data-source/mysql/terraform.tfstate"
  remote_state_aws_region = "us-east-1"
  custer_config = {
    min_cluster_count = 1
    max_cluster_count = 2
  }
  server_port = 8080
  ec2_instance_type = "t2.micro"
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb-nc"
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

