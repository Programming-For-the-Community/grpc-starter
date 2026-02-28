resource "aws_acm_certificate" "grpc_starter_client_cert" {
  domain_name       = "client.grpc-starter.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name        = "gRPC Starter Client SSL Certificate"
    Project     = var.project
    Owner       = var.owner
    Description = "SSL certificate for gRPC web client"
  }
}