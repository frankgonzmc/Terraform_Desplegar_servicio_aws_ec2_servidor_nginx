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