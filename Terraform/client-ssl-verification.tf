resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.grpc_starter_client_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.grpc_starter_client_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.grpc_starter_public.id
  records = [tolist(aws_acm_certificate.grpc_starter_client_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.grpc_starter_client_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}