terraform {
  backend "s3" {
    bucket = "multitier-app-terraform-state-dimrev"
    key = "state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "multitier-app-terraform-state-lock-dimrev"
  }
}