output "invoke_url" {
  value = format("https://%s/%s", aws_api_gateway_base_path_mapping.map_api_to_custom_domain.domain_name, aws_api_gateway_base_path_mapping.map_api_to_custom_domain.base_path)
}