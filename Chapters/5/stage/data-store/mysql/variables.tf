variable "db_usn" {
  type = string
  description = "database username"
  sensitive = true
}

variable "db_pwd" {
  type = string
  description = "database password"
  sensitive = true
}