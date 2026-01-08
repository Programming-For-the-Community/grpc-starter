resource "aws_security_group" "grpc_starter_client_sg" {
  name        = "grpc-starter-client-sg"
  description = "Security group for web client"
  vpc_id      = var.vpc_id

  # Allow HTTPS traffic from internet
  ingress {
    description     = "HTTPS from ALB"
    from_port       = 8443
    to_port         = 8443
    protocol        = "tcp"
    security_groups = [aws_security_group.grpc_starter_client_alb_sg.id]
  }

  # Allow HTTP traffic from internet (optional, for redirect)
  ingress {
    description     = "HTTP from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.grpc_starter_client_alb_sg.id]
  }

  # Allow all outbound only to the gRPC server on port 50051
  egress {
    description = "Outbound to gRPC server"
    from_port   = 50051
    to_port     = 50051
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
    # security_groups = [aws_security_group.grpc_server_sg.id]
  }

  # Allow all outbound traffic (for DynamoDB via VPC endpoint, DNS Resolution, etc)
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