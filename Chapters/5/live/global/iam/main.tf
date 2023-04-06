provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner = "nc-team"
      MangedBy = "Terraform"
    }
  }
}

resource "aws_iam_user" "example_arn_loop" {
  count = length(var.iam_user_names) == 0 ? 3 : length(var.iam_user_names)
  name = length(var.iam_user_names) == 0 ? "tf-up-and-running-nick-${count.index}" : var.iam_user_names[count.index]
}

resource "aws_iam_user" "example_arn_for_each" {
  for_each = toset(var.iam_user_names)
  name = each.value
  dynamic "tags" {
    for_each = var.iam_user_tags
    content {
      key = tags.key
      value = tags.value
    }
  }
}