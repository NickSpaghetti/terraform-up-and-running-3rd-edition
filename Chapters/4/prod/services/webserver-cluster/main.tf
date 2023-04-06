
provider "aws" {
  region = "us-east-1"
}

module "WebService-Cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "nc-terraform-by-example"
  remote_state_bucket = "nc-terraform-up-and-running-state"
  remote_state_key_path = "prod/data-source/mysql/terraform.tfstate"
  remote_state_aws_region = "us-east-1"
  custer_config = {
    min_cluster_count = 2
    max_cluster_count =10
  }
  server_port = 8080
  ec2_instance_type = "m4.large"
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

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name = "scale-out-during-business-hours"
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  autoscaling_group_name = "scale_in_at_night"
  scheduled_action_name  = "scale_in_at_night"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 17 * * *"
}

