resource "aws_cloudwatch_log_group" "grpc_starter_logs" {
  name              = "grpc-starter"
  retention_in_days = 14

  tags = {
    Name        = "gRPC Starter Logs"
    Project     = var.project
    Owner       = var.owner
    Description = "CloudWatch Log Group for gRPC starter AWS resources"
  }
}