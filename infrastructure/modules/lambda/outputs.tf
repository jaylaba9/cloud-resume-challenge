output "lambda_function_arn" {
  description = "Lambda function ARN"
  value = aws_lambda_function.my_lambda.arn
}

output "lambda_invoke_arn" {
  description = "Lambda invoke ARN"
  value = aws_lambda_function.my_lambda.invoke_arn
}