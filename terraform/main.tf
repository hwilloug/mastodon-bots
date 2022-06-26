locals {
  source_dir = "../bots/gpu_bot"
  version    = "0.1.0"
  url        = "https://tavern.antinet.work"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.19"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

variable "BESTBUY_API_KEY" {
  type        = string
  default     = ""
  description = "Key for the Best Buy API"
}

variable "MASTODON_EMAIL" {
  type        = string
  default     = ""
  description = "Email of account for bot"
}

variable "MASTODON_PASSWORD" {
  type        = string
  default     = ""
  description = "Password of account for bot"
}

variable "MASTODON_CLIENT_ID" {
  type        = string
  default     = ""
  description = "Mastodon Client ID"
}

variable "MASTODON_CLIENT_SECRET" {
  type        = string
  default     = ""
  description = "Mastodon Client Secret"
}

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
  source_file = "../bots/gpu_bot/main.py"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "gpu_bot_lambda" {
  function_name    = "gpu_bot_lambda"
  role             = aws_iam_role.terraform_function_role.arn
  handler          = "lambda_function.lambda_handler"
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.gpu_bot_lambda_package.output_base64sha256

  runtime = "python3.9"

  timeout = 10

  environment {
    variables = {
      "BOT_VERSION" : local.version
      "MASTODON_BASE_URL" : local.url
      "BESTBUY_API_KEY" : var.BESTBUY_API_KEY
      "MASTODON_EMAIL" : var.MASTODON_EMAIL
      "MASTODON_PASSWORD" : var.MASTODON_PASSWORD
      "MASTODON_CLIENT_ID" : var.MASTODON_CLIENT_ID
      "MASTODON_CLIENT_SECRET" : var.MASTODON_CLIENT_SECRET
    }
  }
}