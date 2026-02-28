resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.dynamodb"

  route_table_ids = [
    aws_route_table.gRPC_starter_private_rt.id
  ]

  tags = {
    Name        = "gRPC Starter DynamoDB VPC Endpoint"
    Project     = var.project
    Owner       = var.owner
    Description = "VPC Endpoint for DynamoDB for gRPC starter"
  }
}