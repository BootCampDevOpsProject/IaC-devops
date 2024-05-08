variable "AWS_REGION" {
  default = "us-east-1"
}

variable "ami" {
  type = map(any)
  default = {
    "us-east-1" = "ami-03ee1ed2bbc46856e"
  }
}