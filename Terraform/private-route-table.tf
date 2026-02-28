resource "aws_route_table" "gRPC_starter_private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.gRPC_starter_igw.id
  }

  tags = {
    Name        = "gRPC Starter Private Route Table"
    Project     = var.project
    Owner       = var.owner
    Description = "Route table for private subnets for gRPC starter"
  }
}

resource "aws_route_table_association" "gRPC_starter_private1_rta" {
  subnet_id      = aws_subnet.gRPC_starter_private1.id
  route_table_id = aws_route_table.gRPC_starter_private_rt.id
}

resource "aws_route_table_association" "gRPC_starter_private2_rta" {
  subnet_id      = aws_subnet.gRPC_starter_private2.id
  route_table_id = aws_route_table.gRPC_starter_private_rt.id
}

resource "aws_route_table_association" "gRPC_starter_private3_rta" {
  subnet_id      = aws_subnet.gRPC_starter_private3.id
  route_table_id = aws_route_table.gRPC_starter_private_rt.id
}
