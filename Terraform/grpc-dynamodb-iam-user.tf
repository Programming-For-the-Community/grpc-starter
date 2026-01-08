resource "aws_iam_role" "grpc_dynamodb_role" {
  name = "grpc-dynamodb-role"

  assume_role_policy = data.aws_iam_policy_document.grpc_dynamodb_assume_role_policy.json

  tags = {
    Owner       = var.owner
    Project     = var.project
    Description = "IAM Role for gRPC DynamoDB access"
  }
}

data "aws_iam_policy_document" "grpc_dynamodb_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:user/charlie_hahm",
        aws_iam_role.ecx_task_execution_role.arn
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "grpc_dynamodb_role_policy_document" {
  // Policy for accessing DynamoDB table
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:DeleteTable",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_users.name}",
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_users.name}/*"
    ]
  }

  // Policy for accessing DynamoDB stream
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_users.name}/stream/*"
    ]
  }

  // KMS permissions for server-side encryption
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_id}:key/${aws_kms_key.grpc_users_table_key.key_id}"
    ]
  }
}

resource "aws_iam_role_policy" "grpc_dynamodb_role_policy" {
  name   = "grpc-dynamodb-role-policy"
  role   = aws_iam_role.grpc_dynamodb_role.id
  policy = data.aws_iam_policy_document.grpc_dynamodb_role_policy_document.json
}
