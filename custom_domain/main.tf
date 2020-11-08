provider "aws" {
  alias = "us-east-1"
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_acm_certificate" "api_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.domain_name
  }

  provider = aws.us-east-1
}

resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = data.aws_route53_zone.hosted_zone.id
  records = [each.value.record]
  ttl     = 60

  provider = aws.us-east-1
}

resource "aws_acm_certificate_validation" "api_cert" {
  certificate_arn         = aws_acm_certificate.api_certificate.arn
  validation_record_fqdns = [for validation in aws_route53_record.api_cert_validation : validation.fqdn]
  provider                = aws.us-east-1
}

resource "aws_api_gateway_domain_name" "api" {
  certificate_arn = aws_acm_certificate_validation.api_cert.certificate_arn
  domain_name     = aws_acm_certificate.api_certificate.domain_name
}

resource "aws_route53_record" "api_subdomain_A" {
  name    = aws_api_gateway_domain_name.api.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.hosted_zone.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.api.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api.cloudfront_zone_id
  }
}


resource "aws_api_gateway_base_path_mapping" "map_api_to_custom_domain" {
  api_id      = var.aws_api_gateway_rest_api_id
  stage_name  = var.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
  base_path   = var.base_path
}
