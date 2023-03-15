output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "Arn of the S3 bucket that stores TF state"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "Name of the AWS DynamoDB table name that stores the TF state file"
}