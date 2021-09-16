terraform {
  required_version = "= 1.0.4"

  backend "s3" {
    bucket = "valikkr"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.55"
    }
  }
}
