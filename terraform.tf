terraform {
  backend "s3" {
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    key            = "pca-terraform/terraform.tfstate"
    profile        = "terraform-role" # This profile must be defined in your AWS credentials file
    region         = "us-east-1"
  }
}
