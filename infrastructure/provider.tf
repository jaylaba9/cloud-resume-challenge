terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.86.1"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
 # profile = "my-prod-profile" -> uncomment this line when using Terraform locally(not via GitHub Actions)
}