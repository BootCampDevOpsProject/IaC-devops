# Configuración para la creación de una key_pair de la EC2

# RSA key para 4096 bits 
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Configuración de la key_pair
resource "aws_key_pair" "key_pair" {
  key_name   = "sonar-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Creación de .pem que contiene los valores de la key_pair
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}
