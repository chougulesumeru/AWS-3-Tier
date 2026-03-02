# configure vpc with terraform hashicorp 

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "${local.name_prefix}-vpc"
  }
}

# internate gateway
resource "aws_internate_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "${local.name_prefix}-igw"
  }
}

#public subnets

resource "aws_public_subnet" "public" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = ["0.10.0.0/24", "0.11.0.0/24"]
  azs        = ["us-east-1a", "us-east-1b"]

  tags = {
    name = "${local.name_prefix}-public-subnet"
  }
}

#private subnets 

resource "aws_private_subnet" "private" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs
  azs        = ["us-east-1a", "us-east-1b"]

  tags = {
    name = "${local.name_prefix}-private-subnet"
  }
}

#route tables 

#public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id = aws_internate_gateway.id
    }

    tags= {
        name= "${local.name_prefix}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
    count= length(aws_public_subnet.public)
    subnet_id = aws_public_subnet.public.id
    route_table_id = aws_route_table.public.id
}

#private route table:- NAT gateway 
resource "aws_eip" "nat" {
    domain= "vpc"

    tags= {
        name= "${local.name_prefix}-nat-eip"
    }
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat
    subnet_id = aws_private_subnet.private[0].id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }

    tags= {
        name= "${local.name_prefix}-private-rt"
    }
}

resource "aws_route_table_association" "private" {
    count= length(aws_private_subnet.private)
    subnet_id= aws_private_subnet.private.id
    route_table_id = aws_route_table.private.id 
}