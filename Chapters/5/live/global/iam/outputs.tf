output "user_arns" {
  value = aws_iam_user.example_arn_loop[*].arn
}

output "all_users" {
  value = aws_iam_user.example_arn_for_each.arn
}

output "upper_names" {
  value = [for name in var.iam_user_names : upper(name)]
}

output "upper_tags" {
  value = { for key,value in var.iam_user_tags: upper(key) => upper(value)}
}
output "upper_name_index" {
  value = "%{for name in var.iam_user_names} :(${i})-upper(name), %{ endfor }"
}

output "for_directive_index_if_strip" {
  value = <<EOF
%{~ for i, name in var.iam_user_names ~}
${name}%{ if index(var.iam_user_names,name) < length(var.iam_user_names) - 1 }, %{ endif }
%{~ endfor ~}
EOF
}