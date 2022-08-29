terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "myterrakey.pem"
}

resource "aws_key_pair" "key121" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
}


resource "aws_security_group" "web-sg" {
  name = "aws-default-security-group-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/* resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "sg-026ff8cfda7753a07"
  network_interface_id = "eni-0496c10c0f1f159a8"
} */

resource "aws_instance" "kubernetes" {
  # Creates two identical aws ec2 instances for kubernetes
  count = 2   
  
  # All four instances will have the same ami and instance_type
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key121.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  /* key_name = "emre_aws_kubernetes" */


  tags = {
    Name = "kube-${count.index}"
  }

  connection {
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = tls_private_key.oskey.private_key_pem
    host        = aws_instance.mytfinstance.public_ip
  }

}