terraform {
  required_version = "= 1.0.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.55"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
  }
}
