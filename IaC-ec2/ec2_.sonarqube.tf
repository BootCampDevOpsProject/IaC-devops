resource "aws_spot_instance_request" "webservers_spot" {
  ami              = lookup(var.ami, var.AWS_REGION)
  instance_type    = "t2.medium"
  subnet_id        = "subnet-0c95a663f9f165d3a"
  key_name         = aws_key_pair.key_pair.key_name
  spot_price       = "0.03"  # Precio máximo que estás dispuesto a pagar por hora (ajusta según tus necesidades)
  security_groups  = [aws_security_group.ec2_sg.id]
  instance_interruption_behavior = "terminate"  # Determina el comportamiento cuando la instancia es interrumpida

  tags = {
    Name = "sonarqube-ec2"
    Env  = "Prod"
  }
}
