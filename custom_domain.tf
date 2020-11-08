module "custom_domain" {
  count = var.custom_domain == null ? 0 : 1

  source = "./custom_domain"

  aws_api_gateway_rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = var.stage_name
  base_path = var.custom_domain.base_path
  domain_name = var.custom_domain.domain_name
  hosted_zone_name = var.custom_domain.hosted_zone_name

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}
