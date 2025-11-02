resource "aws_vpc_endpoint" "sts" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.gRPC_starter_private1.id,
    aws_subnet.gRPC_starter_private2.id,
    aws_subnet.gRPC_starter_private3.id
  ]

  security_group_ids = [aws_security_group.grpc_starter_vpc_endpoints_sg.id]

  tags = {
    Name        = "STS VPC Endpoint"
    Project     = var.project
    Owner       = var.owner
    Description = "VPC Endpoint for STS"
  }
}