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
    from_port = var.server_port
    protocol  = "tcp"
    to_port   = var.server_port
    cidr_blocks=["0.0.0.0/0"]
  }
  tags = {
    Name   = "nc-security-group"
    Source = "terraform-up-and-running-3rd-edition"
  }
}

#The use of launch configurations is discouraged in favour of launch templates. Read more in the AWS EC2 Documentation.
resource "aws_launch_configuration" "example_ec2" {
  image_id                    = "ami-0fd2c44049dd805b8"
  instance_type               = "t2.micro"
  user_data_replace_on_change = true
  user_data = templatefile("user-data.sh",{
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
  })
  security_groups = [aws_security_group.instance.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_ec2" {
  launch_configuration = aws_launch_configuration.example_ec2.name
  vpc_zone_identifier = [data.aws_subnet.default.id]
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  max_size = var.custer_config.max_cluster_count
  min_size = var.custer_config.min_cluster_count
    tag = {
      Name   = "nc-ec2-cluster-example"
      Source = "terraform-up-and-running-3rd-edition"
      propagate_at_launch = true
    }
}

data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_subnet.default.id]
  }
}

resource "aws_lb" "example_lb" {
  name = "nc-terraform-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnet.default.id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example_lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: This is not the page you are looking for"
      status_code = "404"
    }
  }
}

resource "aws_security_group" "alb" {
  name = "nc-terraform-example-alb"
  # Allow inbound HTTP requests
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name = "nc-terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_subnet.default.id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config {
    bucket = "nc-terraform-up-and-running-state"
    key = "prod/data-source/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}