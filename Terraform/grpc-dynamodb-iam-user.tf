resource "aws_iam_user" "grpc_dynamodb_user" {
  name = "grpc-dynamodb-user"

  tags = {
    Owner       = var.owner
    Project     = var.project
    Description = "IAM User for gRPC DynamoDB access"
  }
}

resource "aws_iam_access_key" "grpc_dynamodb_access_key" {
  user = aws_iam_user.grpc_dynamodb_user.name
}

data "aws_iam_policy_document" "grpc_dynamodb_user_policy_document" {
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
      "dynamodb:UntagResource"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_dynamodb_table.name}",
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_dynamodb_table.name}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.grpc_dynamodb_table.name}/stream/*"
    ]
  }
}

resource "aws_iam_user_policy" "grpc_dynamodb_user_policy" {
  name   = "grpc-dynamodb-user-policy"
  user   = aws_iam_user.grpc_dynamodb_user.name
  policy = data.aws_iam_policy_document.grpc_dynamodb_user_policy_document.json
}