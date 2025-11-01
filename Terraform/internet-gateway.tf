resource "aws_internet_gateway" "gRPC_starter_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "gRPC Starter Internet Gateway"
    Project     = var.project
    Owner       = var.owner
    Description = "Internet Gateway for gRPC starter project"
  }
}