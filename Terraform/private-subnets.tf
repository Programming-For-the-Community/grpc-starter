resource "aws_subnet" "gRPC_starter_private1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private1_subnet_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name        = "gRPC Starter Private Subnet East 2A"
    Project     = var.project
    Owner       = var.owner
    Description = "Private subnet in ${var.region}a for gRPC starter"
  }
}

resource "aws_subnet" "gRPC_starter_private2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private2_subnet_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name        = "gRPC Starter Private Subnet East 2B"
    Project     = var.project
    Owner       = var.owner
    Description = "Private subnet in ${var.region}b for gRPC starter"
  }
}

resource "aws_subnet" "gRPC_starter_private3" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private3_subnet_cidr
  availability_zone = "${var.region}c"
  tags = {
    Name        = "gRPC Starter Private Subnet East 2C"
    Project     = var.project
    Owner       = var.owner
    Description = "Private subnet in ${var.region}c for gRPC starter"
  }
}