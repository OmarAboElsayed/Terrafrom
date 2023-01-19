
terraform {
  backend "s3" {
    bucket = "bucket-omar-1"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "terraform-up-running-locks"
    encrypt = true
  }
}