variable "iam_user_names" {
  description = "iam user names"
  type = list(string)
  default = ["tfupr-nc-1","tfupr-nc-2"]
}
variable "iam_user_tags" {
  description = "custom tag on iam  users"
  type = map(string)
  default = {}
}

variable "is_security_group_enabled" {
  type = bool
  default = false
}