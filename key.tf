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
