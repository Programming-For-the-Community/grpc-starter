resource "aws_lb" "grpc_server_nlb" {
  name               = "grpc-server-nlb"
  internal           = false # External NLB allows client to connect to server on private subnets
  load_balancer_type = "network"
  subnets = [
    aws_subnet.gRPC_starter_public1.id,
    aws_subnet.gRPC_starter_public2.id,
    aws_subnet.gRPC_starter_public3.id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = "gRPC Internal Network Load Balancer"
    Project     = var.project
    Owner       = var.owner
    Description = "Internal Network Load Balancer for gRPC server"
  }
}

resource "aws_lb_target_group" "grpc_server_tg_grpc" {
  name        = "server-grpc-tg"
  port        = 50051
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 15
    port                = 50051
    protocol            = "TCP"
  }

  deregistration_delay = 30

  tags = {
    Name        = "gRPC Target Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Target group for gRPC server"
  }
}

resource "aws_lb_target_group" "grpc_server_tg_http" {
  name        = "server-http-tg"
  port        = 8080
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 15
    port                = 8080
    protocol            = "HTTP"
    path                = "/health"
  }

  deregistration_delay = 30

  tags = {
    Name        = "gRPC Target Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Target group for HTTP Health Checks"
  }
}

resource "aws_lb_listener" "grpc_server_listener_grpc" {
  load_balancer_arn = aws_lb.grpc_server_nlb.arn
  port              = 50051
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc_server_tg_grpc.arn
  }
}

resource "aws_lb_listener" "grpc_server_listener_http" {
  load_balancer_arn = aws_lb.grpc_server_nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc_server_tg_http.arn
  }
}