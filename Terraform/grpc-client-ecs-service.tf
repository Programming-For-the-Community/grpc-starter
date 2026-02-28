resource "aws_ecs_service" "grpc_client_service" {
  name            = "grpc-client-service"
  cluster         = aws_ecs_cluster.grpc_starter_ecs_cluster.id
  task_definition = aws_ecs_task_definition.grpc_client_task.arn
  desired_count   = 2 # Run 2 tasks for high availability
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.gRPC_starter_public1.id,
      aws_subnet.gRPC_starter_public2.id,
      aws_subnet.gRPC_starter_public3.id
    ]
    security_groups  = [aws_security_group.grpc_starter_client_sg.id]
    assign_public_ip = true # No public IP needed in private subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grpc_starter_client_tg.arn
    container_name   = "grpc-client"
    container_port   = 8080
  }

  #   service_registries {
  #     registry_arn = aws_service_discovery_service.grpc_server_service_discovery.arn
  #   }

  depends_on = [
    aws_lb_listener.grpc_starter_client_listener_http,
    aws_lb_listener.grpc_starter_client_listener_https
  ]

  tags = {
    Name        = "gRPC Client ECS Service"
    Project     = var.project
    Owner       = var.owner
    Description = "ECS Client Service for gRPC server"
  }
}