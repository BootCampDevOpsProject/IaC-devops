# Provider de de AWS con la versión 4.1.0  

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.1.0"
    }
  }
}

# Región en la cual se crearán los recursos en AWS
provider "aws" {
  region = "us-east-1"
}
