output "public_ip" {
  value = aws_launch_configuration.example_ec2.associate_public_ip_address
  description = "The public IP address of the web server"
}

output "alb_dns_name" {
  value = aws_lb.example_lb.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value = "aws_autoscaling_group,example.name"
  description = "The name of the Auto Scaling Group"
}