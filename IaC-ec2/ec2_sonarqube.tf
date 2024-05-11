# Configuración de los parametros para la creación de la EC2 que alojará SonarQube

resource "aws_spot_instance_request" "ec2sonarqube" {
  ami                            = lookup(var.ami, var.AWS_REGION)  # AMI contiene SonarQube
  instance_type                  = "t2.medium"                      # Tipo de instancia a utilizar
  subnet_id                      = "subnet-0c95a663f9f165d3a"       # Id de la subnet previamente creada a utilizar
  key_name                       = aws_key_pair.key_pair.key_name   # Rerenciar key_pair que se utilizará para crearm previamente en el archivo ec2_keypair.tf
  spot_price                     = "0.03" # Precio máximo que estás dispuesto a pagar por hora (ajusta según tus necesidades)  
  wait_for_fulfillment           = "true"                           # Terraform esperará a que se cumpla la solicitud de spot
  security_groups                = [aws_security_group.ec2_sg.id]   # Segurity Group quea a utilizar previamente creaco en el archivo sg.tf 
  instance_interruption_behavior = "terminate" # Determina el comportamiento cuando la instancia es interrumpida

  tags = {
    Name = "ec2sonarqube"  #  Tags de la EC2 
  }
}
