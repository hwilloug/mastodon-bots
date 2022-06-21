terraform {
    required_providers {
        aws = {
            source = "hasicorp/aws"
            version = "=> 4.19"
        }
    }
}

provider aws {
  region  = "us-east-2"
  profile = "default"
}

resource aws_aim_role iam_for_lambda {
    name = "iam_for_lambda"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    ]
}
    EOF
}

resource aws_lambda_function test_lambda {
    function_name = "lambda_function_name"
    role          = aws_aim_role.iam_for_lambda.arn
    
    environment {
        variables = {
            foo = "bar"
        }
    }
}