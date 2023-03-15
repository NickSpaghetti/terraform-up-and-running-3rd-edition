# run init ```terraform init -backend-config=backend.hcl```
bucket = "nc-terraform-up-and-running-state"
region = "us-east-1"
dynamodb_table = "nc-terraform-up-and-running-locks"
encrypt = true