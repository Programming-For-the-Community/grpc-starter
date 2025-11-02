resource "aws_service_discovery_private_dns_namespace" "grpc_server_namespace" {
  name        = "grpc.server.local"
  description = "Private DNS namespace for gRPC service"
  vpc         = var.vpc_id

  tags = {
    Name        = "gRPC Server Service Discovery Namespace"
    Project     = var.project
    Owner       = var.owner
    Description = "Private DNS namespace for gRPC server service discovery"
  }
}

resource "aws_service_discovery_service" "grpc_server_service_discovery" {
  name = "grpc-server"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.grpc_server_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name        = "gRPC Service Discovery"
    Project     = var.project
    Owner       = var.owner
    Description = "Service Discovery for gRPC server"
  }
}

# Private hosted zone for internal DNS
resource "aws_route53_zone" "private" {
  name = "internal.${var.domain_name}"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name    = "Private Hosted Zone for Internal Services"
    Project = var.project
    Owner   = var.owner
  }
}

# Route53 record for internal gRPC server
resource "aws_route53_record" "grpc_server" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "grpc.server.internal.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.grpc_server_nlb.dns_name
    zone_id                = aws_lb.grpc_server_nlb.zone_id
    evaluate_target_health = true
  }
}