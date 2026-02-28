# configure aws vpc with hashicorp terraform

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internate_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "${local.prefix_name}-igw"
  }
}

#configure public subnet
resource "aws_public_subnet" "public" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  azs    = ["us-east-1a", "us-east-1b"]

  tags = {
    name = "${local.prefix_name}-public_subnet"
  }
}

resource "aws_private_subnet" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  azs    = ["us-east-1a", "us-east-1b"]

  tags = {
    name = "${local.prefix_name}-private_subnet"
  }
}

