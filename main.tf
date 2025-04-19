###VARIABLES###

variable "ami_id" {
    description = "ID de la ami para el EC2"
    default = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
    description = "Tipo de  instancia EC2"
    default = "t3.micro"
}

variable "server_name" {
    description = "Nombre del servidor web"
    default = "nginx-server"
}

variable "enviroment" {
    description = "Ambiente de la aplicacion"
    default = "test"
}


###Provider###
provider "aws" {
    region = "us-east-1"
}

###Recurso###
resource "aws_instance" "nginx-server" {
    ami = var.ami_id
    instance_type = var.instance_type
    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl strat nginx
                EOF
    #Conectar la llave con el recurso de la instancia
    key_name = aws_key_pair.nginx-server-ssh.key_name

    #Asignar el security group a la MV
    vpc_security_group_ids = [
        aws_security_group.nginx-server-sg.id
    ]

    tags = {
        Name = var.server_name
        Enviroment = var.enviroment
        Owner = "franktoomg@gmail.com"
        Team = "DevOps"
        Project = "Prueba"
    }
}


###RECURSO PARA CLAVE SSH###
resource "aws_key_pair" "nginx-server-ssh" {
    key_name = "${var.server_name}-ssh"
    #Desde la carpeta raiz usar la llave publica
    public_key = file("${var.server_name}.key.pub")

    tags = {
        Name = "${var.server_name}-ssh"   #Var.server_name + -ssh
        Enviroment = var.enviroment
        Owner = "franktoomg@gmail.com"
        Team = "DevOps"
        Project = "Prueba"
    }
}


###CREAR EL SECURITY GROUP COMO RECURSO PARA LA MV(FIREWALL EN AWS)###
resource "aws_security_group" "nginx-server-sg" {
    name = "${var.server_name}-sg"
    description = "Security group que solo permite conexiones ssh y http"

    #Reglas de entrada:

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #Reglas de salida

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.server_name}-sg"
        Enviroment = var.enviroment
        Owner = "franktoomg@gmail.com"
        Team = "DevOps"
        Project = "Prueba"
    }

}

###OUTPUTS###

output "server_public_ip" {
    description = "Direccion ip publica de la instancia EC2"
    value = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
    description = "DNS publico de la instancia EC2"
    value = aws_instance.nginx-server.public_dns
}