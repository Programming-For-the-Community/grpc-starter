resource "aws_dynamodb_table" "grpc_users" {
  name         = "gRPC-Users-${var.account_id}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "Username"
  range_key = "CurrentLocation"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.grpc_users_table_key.arn
  }

  attribute {
    name = "Username"
    type = "S"
  }

  attribute {
    name = "CurrentLocation"
    type = "S"
  }

  tags = {
    Owner       = var.owner
    Project     = var.project
    Description = "DynamoDB table for ${var.project}"
  }
}