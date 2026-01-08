resource "aws_ecs_service" "grpc_server_service" {
  name            = "grpc-server-service"
  cluster         = aws_ecs_cluster.grpc_starter_ecs_cluster.id
  task_definition = aws_ecs_task_definition.grpc_server_task.arn
  desired_count   = 2 # Run 2 tasks for high availability
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.gRPC_starter_private1.id,
      aws_subnet.gRPC_starter_private2.id,
      aws_subnet.gRPC_starter_private3.id
    ]
    security_groups  = [aws_security_group.grpc_server_sg.id]
    assign_public_ip = false # No public IP needed in private subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grpc_server_tg_grpc.arn
    container_name   = "grpc-server"
    container_port   = 50051
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grpc_server_tg_http.arn
    container_name   = "grpc-server"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.grpc_server_service_discovery.arn
  }

  depends_on = [
    aws_lb_listener.grpc_server_listener_grpc,
    aws_lb_listener.grpc_server_listener_http
  ]

  tags = {
    Name        = "gRPC Server ECS Service"
    Project     = var.project
    Owner       = var.owner
    Description = "ECS Server Service for gRPC server"
  }
}