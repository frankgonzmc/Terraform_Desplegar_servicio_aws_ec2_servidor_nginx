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