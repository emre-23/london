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

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "sg-026ff8cfda7753a07"
  network_interface_id = "eni-0496c10c0f1f159a8"
}

resource "aws_instance" "kubernetes" {
  # Creates two identical aws ec2 instances for kubernetes
  count = 2   
  
  # All four instances will have the same ami and instance_type
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  key_name = "emre_aws_kubernetes"
  /* security_group_id = "sg-026ff8cfda7753a07" */

  tags = {
    Name = "kube-${count.index}"
  }
}