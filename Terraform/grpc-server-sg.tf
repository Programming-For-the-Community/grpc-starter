resource "aws_security_group" "grpc_server_sg" {
  name        = "grpc-server-sg"
  description = "Security group for gRPC server"
  vpc_id      = var.vpc_id

  # Allow gRPC traffic from web client only
  ingress {
    description     = "gRPC from web client"
    from_port       = 50051
    to_port         = 50051
    protocol        = "tcp"
    security_groups = [aws_security_group.grpc_starter_client_sg.id]
  }

  # Allow health check traffic from web client
  ingress {
    description     = "HTTP health checks from web client"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.grpc_starter_client_sg.id]
  }

  # Allow all outbound traffic (for DynamoDB via VPC endpoint)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name        = "gRPC Server Security Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Security group for gRPC server"
  }
}