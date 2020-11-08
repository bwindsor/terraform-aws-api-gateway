resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.deployment_name} API"
  description = var.api_description
  body        = var.openapi_spec_yaml
}

resource "aws_api_gateway_stage" "api_deployed_stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api-deployment.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_deployment" "api-deployment" {
  depends_on = [var.openapi_spec_yaml]

  rest_api_id = aws_api_gateway_rest_api.api.id

  variables = {
    "api_spec_hash" = sha256(var.openapi_spec_yaml)
  }

  lifecycle {
    # See https://github.com/hashicorp/terraform/issues/10674#issuecomment-290767062
    # See https://github.com/terraform-providers/terraform-provider-aws/issues/162#issuecomment-545111082
    create_before_destroy = true
  }
}

/* Throttle limits, enable logging and metrics */
resource "aws_api_gateway_method_settings" "api_throttle_setting" {
  depends_on = [aws_api_gateway_deployment.api-deployment, aws_api_gateway_stage.api_deployed_stage]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_deployed_stage.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit

    metrics_enabled = true
    logging_level   = "INFO"
  }
}
