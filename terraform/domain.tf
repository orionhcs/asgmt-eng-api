resource "aws_api_gateway_domain_name" "lambda_domain" {
  certificate_arn = data.terraform_remote_state.platform.outputs.ecs_domain_certificate_validation_arn
  domain_name     = local.domain_name
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "route_record" {
  name    = aws_api_gateway_domain_name.lambda_domain.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.ecs_domain.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.lambda_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.lambda_domain.cloudfront_zone_id
  }
}
