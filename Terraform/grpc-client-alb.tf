# Application Load Balancer for web client
resource "aws_lb" "grpc_starter_client_alb" {
  name               = "grpc-starter-client-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grpc_starter_client_alb_sg.id]

  subnets = [
    aws_subnet.gRPC_starter_public1.id,
    aws_subnet.gRPC_starter_public2.id,
    aws_subnet.gRPC_starter_public3.id
  ]

  enable_deletion_protection = false
  enable_http2               = true

  tags = {
    Name        = "gRPC Web Client ALB"
    Project     = var.project
    Owner       = var.owner
    Description = "Internet-facing Application Load Balancer for web client"
  }
}

# Target group for web client
resource "aws_lb_target_group" "grpc_starter_client_tg" {
  name        = "grpc-starter-client-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Name        = "gRPC Web Client Target Group"
    Project     = var.project
    Owner       = var.owner
    Description = "Target group for web client"
  }
}

# HTTP listener (redirect to HTTPS)
resource "aws_lb_listener" "grpc_starter_client_listener_http" {
  load_balancer_arn = aws_lb.grpc_starter_client_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener
resource "aws_lb_listener" "grpc_starter_client_listener_https" {
  load_balancer_arn = aws_lb.grpc_starter_client_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.grpc_starter_client_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc_starter_client_tg.arn
  }

  depends_on = [
    aws_acm_certificate_validation.cert # Depends on SSL Cert
  ]
}