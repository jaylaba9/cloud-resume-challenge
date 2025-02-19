################
# MAIN TERRAFORM FILE THAT RUNS THE WHOLE CONFIGURATION
################

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.table_name
}

module "iam" {
  source = "./modules/iam"
}

module lambda {
  source = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  lambda_function_path = var.lambda_function_path
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_role_arn = module.iam.lambda_role_arn
}