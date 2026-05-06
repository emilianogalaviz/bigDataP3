# Buscar el rol de AWS Academy
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_s3_bucket" "transactions_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

module "lambda_validate" {
  source          = "./modules/lambda_function"
  function_name   = "${var.project_name}-validate"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.12"
  source_dir      = "${path.module}/lambdas/validate"
  lambda_role_arn = data.aws_iam_role.lab_role.arn
}

module "lambda_risk_assess" {
  source          = "./modules/lambda_function"
  function_name   = "${var.project_name}-risk-assess"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.12"
  source_dir      = "${path.module}/lambdas/risk_assess"
  lambda_role_arn = data.aws_iam_role.lab_role.arn
}

module "lambda_route" {
  source          = "./modules/lambda_function"
  function_name   = "${var.project_name}-route"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.12"
  source_dir      = "${path.module}/lambdas/route"
  lambda_role_arn = data.aws_iam_role.lab_role.arn

  environment_variables = {
    BUCKET_NAME = aws_s3_bucket.transactions_bucket.id
  }
}
