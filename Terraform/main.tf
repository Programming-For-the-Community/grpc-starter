terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }

  backend "s3" {
    bucket = "aws-grpc-starter-tfstate-048908104884"
    region = "us-east-2"
    key    = "aws-grpc-starter.tfstate"
  }

}

provider "aws" {
  region = var.region
}