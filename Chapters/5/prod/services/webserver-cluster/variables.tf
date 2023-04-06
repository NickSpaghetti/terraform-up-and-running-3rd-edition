variable "cluster_name" {
  description = "Name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "is_autoscaling_scheduled_enabled" {
  description = "If set to true enables autoscaling"
  type = bool
}