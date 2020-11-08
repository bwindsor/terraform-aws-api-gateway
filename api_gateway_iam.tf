/* API execution role */
resource "aws_iam_role" "iam_for_api_gateway" {
  name = "${var.deployment_name}-api-gateway-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

/* Attach any additionally provided policies to the API gateway role */
resource "aws_iam_role_policy_attachment" "additional_policies" {
  for_each = var.additional_policy_arns

  policy_arn = each.value
  role = aws_iam_role.iam_for_api_gateway.name
}
