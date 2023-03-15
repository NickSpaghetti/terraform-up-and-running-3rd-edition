output "public_ip" {
  value       = aws_instance.example_ec2.public_ip
  description = "The public IP address of the web server"
}