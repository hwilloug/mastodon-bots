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
  region  = "us-east-2"
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

data "archive_file" "python_lambda_pachage" {
  type        = "zip"
  source_file = "../bots/gpu_bot/lambda_function.py"
  output_path = "nametest.zip"
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "nametest.zip"

  runtime = "python3.9"

  timeout = 10

  environment {
    variables = {
      foo = "bar"
    }
  }
}