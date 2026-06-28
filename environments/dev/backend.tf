terraform {
  backend "s3" {
    bucket         = "gb-tf-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    # dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}