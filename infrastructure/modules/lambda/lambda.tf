data "archive_file" "lambda_function_package" {
  type = "zip"
  source_file = var.lambda_function_path
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "my_lambda" {
  filename = "lambda.zip"
  function_name = var.lambda_function_name
  role = var.lambda_role_arn
  source_code_hash = data.archive_file.lambda_function_package.output_base64sha256
  handler = var.lambda_handler
  runtime = var.lambda_runtime
}