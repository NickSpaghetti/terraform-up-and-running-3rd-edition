variable "server_port" {
  type        = number
  description = "port number for your server"
}

variable "custer_config" {
  type = object({
    min_cluster_count: number,
    max_cluster_count: number
  })
  description = "Minimum number of clusters in the ASG"
}

variable "cluster_name" {
  description = "Name to use for all the cluster resources"
  type = string
}

variable "remote_state_bucket" {
  description = "name of the remote state bucket"
  type = string
}
variable "remote_state_key_path" {
  description = "file path of the remote state key"
  type = string
}

variable "remote_state_aws_region" {
  description = "aws region of the remote state"
  type = string
}

variable "ec2_instance_type" {
  description = "The tyep of EC2 instance to run (e.g. t2.micro)"
  type = string
}