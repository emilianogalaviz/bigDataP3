data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/files/${var.function_name}.zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = var.handler # Usamos la variable que viene del main.tf
  runtime          = var.runtime # Usamos la variable que viene del main.tf
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # AWS acepta un mapa vacío aquí si no hay variables
  environment {
    variables = var.environment_variables
  }
}
