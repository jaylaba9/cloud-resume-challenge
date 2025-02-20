resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = trim(var.resource_path, "/")
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST" # API GW always sent POST to lambda
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST" # API GW always sent POST to lambda
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  depends_on = [ 
    aws_api_gateway_integration.get_integration, 
    aws_api_gateway_integration.post_integration ]
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = "prod"
}

# LAMBDA
resource "aws_lambda_permission" "apigw_lambda" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}