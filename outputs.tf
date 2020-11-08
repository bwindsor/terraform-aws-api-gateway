output "execution_arn" {
  value = aws_api_gateway_stage.api_deployed_stage.execution_arn
  description = "Execution ARN for the API deployment"
}

output "aws_api_gateway_rest_api_id" {
  value = aws_api_gateway_rest_api.api.id
  description = "API ID for the API deployment"
}

output "api_name" {
  value = aws_api_gateway_rest_api.api.name
  description = "API name of the API"
}

output "invoke_url" {
  value = var.custom_domain == null ? aws_api_gateway_deployment.api-deployment.invoke_url : module.custom_domain[0].invoke_url
  description = "Full URL to use to invoke the API, for example https://api.example.com/v1"
}

output "domain_name" {
  value = var.custom_domain == null ? substr(aws_api_gateway_deployment.api-deployment.invoke_url, 0, length(aws_api_gateway_deployment.api-deployment.invoke_url - length(var.stage_name) - 1)) : module.custom_domain[0].domain_name
  description = "Domain name the API is hosted at, for example api.example.com"
}