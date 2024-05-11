# Variables

# Variable de la región a utilizar
variable "AWS_REGION" {
  default = "us-east-1"
}

# ID de la AMI a utilizar para la creación de la EC2 con SonarQube
variable "ami" {
  type = map(any)
  default = {
    "us-east-1" = "ami-03ee1ed2bbc46856e"
  }
}
