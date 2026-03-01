resource "aws_key_pair" "key_name" {
  key_name   = "terra-3-tier-key"
  public_key = file("/home/sumeru-chougule/AWS-DevOps/terraform-3-tier/terra-3-tier.pem")
}

#bastion (public)
resource "aws_bastion" "bastion" {
  ami              = var.ami_id.id
  instance_type    = "t2.micro"
  subnet_id        = aws_public_subnet.public[0].id
  vpc_security_ids = [aws_security_group.bastion.id]

  tags = {
    name = "${local.name_prefix}-bastion"
  }
}


#application server (private)
resource "aws_instance" "app" {
  ami                    = var.ami_id_private.id
  instance_type          = var.instance_type
  subnet_id              = aws_private_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOT

    #!/bin/bash

    sudo apt update && apt upgrade 
    sudo apt install nginx
    systemctl start nginx
    systemctl enable nginx
    systemctl status enginx

    echo "<h1> Hello ! shiban darling </h1>" > /usr/share/nginx/html/index.html

    EOT 

  tags = {
    name = "${local.name_prefix}-app-01"
  }
}

#latest amazon linux 2023 (ARM version)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*arm64"]
  }

  filter {
    name   = "virtulization-type"
    values = ["hvm"]
  }
}
