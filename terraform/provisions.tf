provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "consul_server_sg" {
  name        = "default"
  description = "Security group for the consul server"

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 0
  #   to_port     = 65000
  #   protocol    = "tcp"
  #   cidr_blocks = ["172.31.0.0/16"]
  # }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "consul-server-sg"
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHaM/DhbzbM0sG5DBP5ldfPFzguYJdtg/tl9/Uw3FKXLYPHauoiYqCztKtyuek1nGExSAeLPqUdOPafBjFgDk+Ziz8fmj4/rUkSmNeIdddsZGpxYhb8F273ftCrIhlvk+KX+AsvffJUiGvZ/dALC8EG1E2YXUSlB2alM1VHiCbNHV5AUWVteIWho99chO6WAljFH7R6kq23t/eP5hPOmd0Gtgw0H8PCMab58GbItviJGcigTct0lBTx1DSCEGpUobvEjnSBJ8ZnDsZT9CPRHcWe8u8RrOUzeI7hP+YA7kR28vIH6btsy1MtPufFimTNTnGoPc2Emy1NWPpkA7B1+CR kimang@KIMs-MacBook-Pro.local"
}

resource "aws_instance" "consul_server" {
  ami                    = "ami-ff0fea8310f3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.consul_server_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  user_data_replace_on_change = true
  user_data                   = <<-EOF
              #!/bin/bash
              apt update -y
              apt install python3 -y
            EOF

  tags = {
    Name = "consul-server"
  }
}

resource "aws_instance" "load_balancer" {
  ami                    = "ami-ff0fea8310f3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.consul_server_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  user_data_replace_on_change = true
  user_data                   = <<-EOF
              #!/bin/bash
              apt update -y
              apt install python3 -y
            EOF

  tags = {
    Name = "loadbalancer"
  }
}

resource "aws_instance" "backends" {
  count                  = 3
  ami                    = "ami-ff0fea8310f3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.consul_server_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  user_data_replace_on_change = true
  user_data                   = <<-EOF
              #!/bin/bash
              apt update -y
              apt install python3 -y
            EOF

  tags = {
    Name = "backend-app"
  }
}