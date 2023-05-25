
data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yml")

}
data "aws_vpc" "main" {
  id = var.vpc_id
}
data "aws_ami" "ubuntu" {
  
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "my_east_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  tags = {
    Name = "Server-East"
  }
}
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = "main-key"
  vpc_security_group_ids = [aws_security_group.allow_web_sg.id]
  user_data              = data.template_file.user_data.rendered
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/ADMIN/Desktop/Test-key/main-key.pem")
    host        = self.public_ip
  }

  tags = {
    Name = var.server_name
  }
}




resource "aws_security_group" "allow_web_sg" {
  name        = "allow_web_sg"
  description = "allow_web_sg"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_with_cidr]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}


