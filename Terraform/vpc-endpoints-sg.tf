# Security Group for VPC Endpoints
resource "aws_security_group" "grpc_starter_vpc_endpoints_sg" {
  name        = "grpc-starter-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      var.private1_subnet_cidr,
      var.private2_subnet_cidr,
      var.private3_subnet_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "VPC Endpoints Security Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Security group for VPC endpoints"
  }
}