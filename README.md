# terraform-aws-api-gateway
Provides resources to deploy to API gateway, optionally with a custom domain name.

# Usage
```hcl-terraform
module "api" {
  source = "bwindsor/api-gateway/aws"
  deployment_name = "tf-my-project"
  stage_name = "prod"
  api_description = "My API"
  openapi_spec_yaml = file("api-spec.yaml")

  # Optional
  throttling_burst_limit = 1000
  throttling_rate_limit = 2000
  additional_policy_arns = [aws_iam_policy.invoke_lambda_policy.arn]
  
  # Supply this if you want a custom domain name. This config would give you https://api.example.com/v1 as the API root path
  custom_domain = {
    base_path = "v1"
    domain_name = "api.example.com"
    hosted_zone_name = "example.com"
  }
}
```
