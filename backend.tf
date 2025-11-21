terraform {
  backend "s3" {
    bucket         = "my-terraform-state-rafraz"
    key            = "lambda/api-gateway/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
