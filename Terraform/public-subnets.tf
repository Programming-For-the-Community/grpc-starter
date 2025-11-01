resource "aws_subnet" "gRPC_starter_public1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public1_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "gRPC Starter Public Subnet East 2A"
    Project     = var.project
    Owner       = var.owner
    Description = "Public subnet in ${var.region}a for gRPC starter"
  }
}

resource "aws_subnet" "gRPC_starter_public2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public2_subnet_cidr
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name        = "gRPC Starter Public Subnet East 2B"
    Project     = var.project
    Owner       = var.owner
    Description = "Public subnet in ${var.region}b for gRPC starter"
  }
}

resource "aws_subnet" "gRPC_starter_public3" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public2_subnet_cidr
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name        = "gRPC Starter Public Subnet East 2C"
    Project     = var.project
    Owner       = var.owner
    Description = "Public subnet in ${var.region}c for gRPC starter"
  }
}