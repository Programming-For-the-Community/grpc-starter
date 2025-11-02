resource "aws_cloudwatch_log_group" "grpc_server_logs" {
  name              = "grpc-server"
  retention_in_days = 14

  tags = {
    Name        = "gRPC Server Logs"
    Project     = var.project
    Owner       = var.owner
    Description = "CloudWatch Log Group for gRPC server logs"
  }
}