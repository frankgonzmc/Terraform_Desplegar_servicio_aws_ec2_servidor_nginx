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
}


###RECURSO PARA CLAVE SSH###
resource "aws_key_pair" "nginx-server-ssh" {
    key_name = "nginx-server-ssh"
    #Desde la carpeta raiz usar la llave publica
    public_key = file("nginx-server.key.pub")
}