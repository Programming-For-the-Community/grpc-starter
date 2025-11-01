resource "aws_route_table" "gRPC_starter_public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.gRPC_starter_igw.id
  }

  tags = {
    Name        = "gRPC Starter Public Route Table"
    Project     = var.project
    Owner       = var.owner
    Description = "Route table for public subnets for gRPC starter"
  }
}

resource "aws_route_table_association" "gRPC_starter_public_rta" {
  count          = 3
  subnet_id      = aws_subnet.gRPC_starter_public[count.index + 1].id
  route_table_id = aws_route_table.gRPC_starter_public_rt.id
}
