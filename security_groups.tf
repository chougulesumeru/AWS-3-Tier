# configure security groups 

resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "bastion host security group"
  vpc_id      = aws_vpc.main.id

  #inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from your IP"
  }
  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0./0"]
  }

  tags = {
    name = "${local.name_prefix}-bastion-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  vpc_id      = aws_vpc.main.id
  description = "application security group"

  #inbound rules
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "SSH from bastion"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    description     = "HTTP from anywhere"
    security_groups = ["0.0.0.0/0"]
  }

  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    name = "${local.name_prefix}-app-sg"
  }
}
