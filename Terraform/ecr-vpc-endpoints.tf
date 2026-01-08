# VPC Endpoint for ECR API (required)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.gRPC_starter_private1.id,
    aws_subnet.gRPC_starter_private2.id,
    aws_subnet.gRPC_starter_private3.id
  ]

  security_group_ids = [aws_security_group.grpc_starter_vpc_endpoints_sg.id]

  tags = {
    Name    = "ECR API VPC Endpoint"
    Project = var.project
    Owner   = var.owner
  }
}

# VPC Endpoint for ECR Docker (required)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.gRPC_starter_private1.id,
    aws_subnet.gRPC_starter_private2.id,
    aws_subnet.gRPC_starter_private3.id
  ]

  security_group_ids = [aws_security_group.grpc_starter_vpc_endpoints_sg.id]

  tags = {
    Name    = "ECR Docker VPC Endpoint"
    Project = var.project
    Owner   = var.owner
  }
}

# VPC Endpoint for S3 (required for ECR layer downloads)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.gRPC_starter_private_rt.id
  ]

  tags = {
    Name    = "S3 Gateway VPC Endpoint"
    Project = var.project
    Owner   = var.owner
  }
}