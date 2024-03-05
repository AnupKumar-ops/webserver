terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.56"
    }
  }
  backend "s3" {
    bucket         = "anup-terraform-s3-bucket"
    region         = "ap-south-1"
    key            = "mystate/terraform.tfstate"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }

}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}
