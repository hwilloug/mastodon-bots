data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "terraform_function_role" {
  name               = "terraform_function_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = aws_iam_role.terraform_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "gpu_bot_lambda_package" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${var.function_name}-lambda.zip"
}

resource "aws_lambda_function" "gpu_bot_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.terraform_function_role.arn
  handler          = "lambda_function.lambda_handler"
  filename         = "${var.function_name}-lambda.zip"
  source_code_hash = data.archive_file.gpu_bot_lambda_package.output_base64sha256

  runtime = "python3.9"

  timeout = 10

  environment {
    variables = {
      "BOT_VERSION" : var.bot_version
      "MASTODON_BASE_URL" : local.url
      "MASTODON_EMAIL" : var.MASTODON_EMAIL
      "MASTODON_PASSWORD" : var.MASTODON_PASSWORD
      "MASTODON_CLIENT_ID" : var.MASTODON_CLIENT_ID
      "MASTODON_CLIENT_SECRET" : var.MASTODON_CLIENT_SECRET
    }
  }
}