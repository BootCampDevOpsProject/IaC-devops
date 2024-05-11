# Creación del Security Group

resource "aws_security_group" "ec2_sg" {
  name        = "sonarqube-sg-ec2-test"
  description = "Allow http inbound traffic"

# Puerto y protoco para conectarse a la instancia desde cualquier IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Puerto por el cual corre SonarQube
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Permitir el trafico de todos los puertos (TCP, UDP)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Tag del Security Group
  tags = {
    Name = "terraform-ec2-security-group"
  }
}
