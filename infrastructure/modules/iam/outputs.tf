output lambda_role_arn {
  description = "ARN of IAM Role for Lambda"
  value = aws_iam_role.lambda_role.arn
}