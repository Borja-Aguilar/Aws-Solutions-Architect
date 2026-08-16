terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1" # Cambia por tu región de preferencia
}

# 1. Grupo de Seguridad (Abrir puertos 80 y 22)
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Permitir trafico HTTP y SSH"

  ingress {
    description = "HTTP desde cualquier lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # En producción, restringe a tu IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Instancia EC2 con User Data vinculado
resource "aws_instance" "web_server" {
  ami           = "ami-0c1c30571d2dae5c9" # Ubuntu 22.04 LTS (Asegúrate de usar una AMI válida para tu región)
  instance_type = "t3.micro"

  security_groups = [aws_security_group.web_sg.name]

  # Vincular el script externo de User Data
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name        = "ServidorWeb-Produccion"
    Environment = "Dev"
  }
}

# 3. Mostrar la IP pública al finalizar la ejecución
output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "IP pública para acceder al sitio web"
}
