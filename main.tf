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
} 