resource "aws_security_group" "grpc_starter_web_client_sg" {
  name        = "grpc-starter-web-client-sg"
  description = "Security group for web client"
  vpc_id      = var.vpc_id

  # Allow HTTPS traffic from internet
  ingress {
    description = "HTTPS from internet"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  # Allow HTTP traffic from internet (optional, for redirect)
  ingress {
    description = "HTTP from internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name        = "gRPC Starter Web Client Security Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Security group for gRPC web client"
  }
}