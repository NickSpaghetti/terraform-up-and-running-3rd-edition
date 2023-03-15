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