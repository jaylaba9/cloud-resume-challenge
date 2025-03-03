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
  profile = terraform.workspace == "default" ? "my-prod-profile" : null # use profile when using Terraform locally, otherwise don't use one(for GitHub actions)
}