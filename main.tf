###Provider###
provider "aws" {
    region = "us-east-1"
}

###Recurso###
resource "aws_instance" "nginx-server" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t3.micro"
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
}


###RECURSO PARA CLAVE SSH###
resource "aws_key_pair" "nginx-server-ssh" {
    key_name = "nginx-server-ssh"
    #Desde la carpeta raiz usar la llave publica
    public_key = file("nginx-server.key.pub")
}


###CREAR EL SECURITY GROUP COMO RECURSO PARA LA MV(FIREWALL EN AWS)###
resource "aws_security_group" "nginx-server-sg" {
    name = "nginx-server-sg"
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

}