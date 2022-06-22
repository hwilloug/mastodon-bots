locals {
  source_dir = "../bots/gpu_bot"
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

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "gpu_bot_lambda_package" {
  type        = "zip"
  source_dir  = local.source_dir
  output_path = "lambda-pkg.zip"
}

resource "aws_lambda_function" "gpu_bot_lambda" {
  function_name = "gpu_bot_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda-pkg.zip"

  runtime = "python3.9"

  timeout = 10

  environment {
    variables = {
      foo = "bar"
    }
  }
}