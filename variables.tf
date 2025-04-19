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