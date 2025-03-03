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

module api_gateway {
  source = "./modules/api_gateway"
  api_name = var.api_name
  resource_path = var.resource_path
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

terraform {
  backend "s3" {
    bucket = "crc-tfstatebucket"
    key = "terraform.tfstate"
    region = eu-central-1
    use_lockfile = true
  }
}