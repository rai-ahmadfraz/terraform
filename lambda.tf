# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role_lambda" {
  name               = "iam_role_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Package the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/index.zip"
}

# Lambda function
resource "aws_lambda_function" "comments-api-service" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "comments-api-service"
  role             = aws_iam_role.iam_role_lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "production"
    Application = "comments-api-service"
  }
}