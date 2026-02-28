# Security group for ALB
resource "aws_security_group" "grpc_starter_client_alb_sg" {
  name        = "grpc-starter-client-alb-sg"
  description = "Security group for web client ALB"
  vpc_id      = var.vpc_id

  # Allow HTTP from internet
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  # Allow HTTPS from internet
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  # Allow outbound to web client containers
  egress {
    description = "To web client containers"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # security_groups = [aws_security_group.grpc_starter_client_sg.id]
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name        = "gRPC Web Client ALB Security Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Security group for web client ALB"
  }
}