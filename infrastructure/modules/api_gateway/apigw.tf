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

resource "aws_api_gateway_method" "options_method" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = "OPTIONS"
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

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type = "MOCK"
  
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "get_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "post_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  depends_on = [ aws_api_gateway_method_response.options_200 ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  depends_on = [ 
    aws_api_gateway_integration.get_integration, 
    aws_api_gateway_integration.post_integration ]
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api))
  }
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