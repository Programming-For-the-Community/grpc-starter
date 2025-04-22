resource "aws_kms_key" "grpc_users_table_key" {
  description         = "KMS key for gRPC Users table"
  enable_key_rotation = true

  tags = {
    Owner   = var.owner
    Project = var.project
    Description = "KMS key for gRPC Users table"
  }
}