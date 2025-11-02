resource "aws_ecs_cluster" "grpc_starter_ecs_cluster" {
  name = "grpc-starter-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "gRPC ECS Cluster"
    Project     = var.project
    Owner       = var.owner
    Description = "ECS Cluster for gRPC starter project"
  }
}