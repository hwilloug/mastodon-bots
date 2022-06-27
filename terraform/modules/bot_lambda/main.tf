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
  name               = "${var.function_name}_terraform_function_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = aws_iam_role.terraform_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${var.function_name}-lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.terraform_function_role.arn
  handler          = "main.run"
  filename         = "${var.function_name}-lambda.zip"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  layers           = [
    "arn:aws:lambda:us-east-2:132507767948:layer:requestsLayer:1",
    "arn:aws:lambda:us-east-2:132507767948:layer:mastodonLayer:1"
  ]

  runtime = "python3.9"

  timeout = 10

  environment {
    variables = {
      "BESTBUY_API_KEY" : data.aws_ssm_parameter.bestbuy_api_key.value
      "BOT_VERSION" : var.bot_version
      "MASTODON_BASE_URL" : var.mastodon_url
      "MASTODON_EMAIL" : try(var.bot_email, data.aws_ssm_parameter.test_bot_email.value)
      "MASTODON_PASSWORD" : try(var.bot_password, data.aws_ssm_parameter.test_bot_password.value)
      "MASTODON_CLIENT_ID" : data.aws_ssm_parameter.mastodon_client_id.value
      "MASTODON_CLIENT_SECRET" : data.aws_ssm_parameter.mastodon_client_secret.value
    }
  }
}

resource "aws_cloudwatch_event_rule" "bot_schedule" {
  name                = "${var.function_name}_job"
  description         = "${var.function_name} trigger"
  schedule_expression = "cron(${var.cron_schedule})"
}

resource "aws_cloudwatch_event_target" "bot_target" {
  rule      = aws_cloudwatch_event_rule.bot_schedule.name
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "bot_schedule_permission" {
  statement_id = "AllowExecutionFromCloudwatch"
  action       = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bot_schedule.arn
}
data "aws_ssm_parameter" "bestbuy_api_key" {
  name        = "BESTBUY_API_KEY"
}

data "aws_ssm_parameter" "mastodon_client_id" {
  name        = "MASTODON_CLIENT_ID"
}

data "aws_ssm_parameter" "mastodon_client_secret" {
  name        = "MASTODON_CLIENT_SECRET"
}

data "aws_ssm_parameter" "test_bot_email" {
  name        = "test_bot_email"
}

data "aws_ssm_parameter" "test_bot_password" {
  name        = "test_bot_password"
}
