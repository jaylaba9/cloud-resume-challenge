################
# MAIN TERRAFORM FILE THAT RUNS THE WHOLE CONFIGURATION
################

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.table_name
}