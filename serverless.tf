data "aws_iam_role" "iam_for_lambda" {
  name = "LabRole"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "code.zip"
}


resource "aws_lambda_function" "workshop_lambda" {
  function_name = "lambda-workshop-terraform"
  role          = data.aws_iam_role.iam_for_lambda.arn
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 256

  filename         = "code.zip"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256

  tags = {
    Name        = "Lambda Fn Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}
