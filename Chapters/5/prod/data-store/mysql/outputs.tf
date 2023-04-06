output "db_address" {
  value = aws_db_instance.mysql.address
  description = "Database address you connect to"
}
output "db_port" {
  value = aws_db_instance.mysql.port
  description = "Database port you connect with"
}