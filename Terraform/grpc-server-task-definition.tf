resource "aws_ecs_task_definition" "grpc_server_task" {
  family                   = "grpc-server"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024 # 1 vCPU
  memory                   = 2048 # 2048 MB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "grpc-server"
      image     = var.server_image
      essential = true

      portMappings = [
        {
          containerPort = 50051
          hostPort      = 50051
          protocol      = "tcp"
          name          = "grpc"
        },
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          name          = "health"
        },
        {
          containerPort = 8443
          hostPort      = 8443
          protocol      = "tcp"
          name          = "tls-health"
        }
      ]

      environment = [
        {
          name  = "AWS_REGION"
          value = var.region
        },
        {
          name  = "GRPC_DYNAMODB_ROLE_ARN"
          value = aws_iam_role.grpc_dynamodb_role.arn
        },
        {
          name  = "TABLE_NAME"
          value = aws_dynamodb_table.grpc_users.name
        },
        {
          name  = "TABLE_STREAM_ARN"
          value = aws_dynamodb_table.grpc_users.stream_arn
        },
        {
          name  = "APP_VERSION"
          value = var.server_version
        },
        {
          name  = "AWS_SECRET_NAME"
          value = var.server_secret
        },
        {
          name  = "NODE_ENV"
          value = "AWS"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.grpc_starter_logs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "/ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://0.0.0.0:8080/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 150
      }
    }
  ])

  depends_on = [aws_dynamodb_table.grpc_users] # Need DynamoDB Table to be up for This service to be able to to run
  tags = {
    Name        = "gRPC Server Task Definition"
    Project     = var.project
    Owner       = var.owner
    Description = "ECS Task Definition for gRPC server"
  }
}