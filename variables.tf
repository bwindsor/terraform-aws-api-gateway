variable "deployment_name" {
  description = "Name of the deployment"
  type        = string
}

variable "stage_name" {
  description = "Stage name for the deployment"
  type        = string
}

variable "api_description" {
  description = "Description for the API"
  type = string
}

variable "openapi_spec_yaml_template" {
  description = <<EOF
Open API YAML template describing the API. If you do not wish to use a template, just provide the ready yaml file without any sub variables

The following substitution variables can be used:
  * api_execution_role_arn - will be completed with the ARN of the role assumed by API gateway
  * options - will be completed with a full OPTIONS method configuration with appropriate CORS headers
EOF
  type = string
}

variable "openapi_spec_variables" {
  type = map(string)
  description = "Variables to be subsituted into the provided YAML template"
  default = {}
}

variable "allowed_origins" {
  type = list(string)
  description = "List of allowed origins for CORS headers. Used for subsitution of access_control_allow_origin_response_template back in to openapi_spec_yaml_template"
  default = []
}

variable "throttling_burst_limit" {
  description = "Burst limit for throttling (bucket size in token bucket algorithm)"
  type = number
  default = 1000
}

variable "throttling_rate_limit" {
  description = "Throttling rate limit, this is the maximum sustained request rate per second"
  type = number
  default = 2000
}

variable "additional_policy_arns" {
  description = "List of IAM policy ARNs to attach to the API gateway role. For example, if API gateway will need to invoke lambda functions, give it permission here"
  type = set(string)
  default = []
}

variable "custom_domain" {
  type = object({
    base_path = string
    domain_name = string
    hosted_zone_name = string
  })
  default = null
  description = <<EOF
Custom domain configuration. If supplied, a certificate will be generated and attached to the API gateway deployment.

base_path: string - the subpath to use for the custom domain, for example to use https://api.example.com/v1 set base_path = "v1"

domain_name: string - the domain name to host the API at, for example to use https://api.example.com/v1 set domain_name = "api.example.com"

hosted_zone_name: string - the hosted zone name to use for SSL certificates, for example hosted_zone_name = "example.com"
  EOF
}
