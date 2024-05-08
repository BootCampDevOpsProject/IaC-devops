resource "aws_instance" "webservers" {
  ami             = lookup(var.ami, var.AWS_REGION)
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ec2_sg.id]
  subnet_id       = "subnet-0c95a663f9f165d3a"
  key_name        = aws_key_pair.key_pair.key_name
  

  tags = {
    Name = "sonarqube-ec2"
    Env  = "Prod"
  }
}