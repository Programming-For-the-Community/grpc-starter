resource "aws_ecs_task_definition" "grpc_client_task" {
  family                   = "grpc-client"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512  # 1 vCPU
  memory                   = 1024 # 2048 MB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "grpc-client"
      image     = var.client_image
      essential = true

      portMappings = [
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
          name  = "APP_VERSION"
          value = var.client_version
        },
        {
          name  = "AWS_SECRET_NAME"
          value = var.server_secret
        },
        {
          name  = "FLUTTER_ENV"
          value = "AWS"
        },
        {
          name  = "FLUTTER_SECRET"
          value = var.client_secret
        },
        {
          name  = "GRPC_HOST"
          value = aws_lb.grpc_server_nlb.dns_name
        },
        {
          name  = "SERVER_URL"
          value = "https://${aws_route53_record.grpc_client.name}"
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

  tags = {
    Name        = "gRPC Client Task Definition"
    Project     = var.project
    Owner       = var.owner
    Description = "ECS Task Definition for gRPC client"
  }
}