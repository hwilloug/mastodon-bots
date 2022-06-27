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

data "aws_ssm_parameter" "gpu_bot_email" {
  name = "GPU_BOT_EMAIL"
}

data "aws_ssm_parameter" "gpu_bot_password" {
  name = "GPU_BOT_PASSWORD"
}

data "aws_ssm_parameter" "clickbait_bot_email" {
  name = "clickbait_bot_email"
}

data "aws_ssm_parameter" "clickbait_bot_password" {
  name = "clickbait_bot_password"
}

module "gpu_bot" {
  source      = "./modules/bot_lambda"
  source_file = "../bots/gpu_bot/main.py"

  bot_email     = data.aws_ssm_parameter.gpu_bot_email.value
  bot_password  = data.aws_ssm_parameter.gpu_bot_password.value
  bot_version   = "0.1.0"
  function_name = "gpu_bot"
  mastodon_url  = "https://tavern.antinet.work"
}

module "clickbait_bot" {
  source      = "./modules/bot_lambda"
  source_file = "../bots/clickbait_bot/main.py"

  bot_email     = data.aws_ssm_parameter.clickbait_bot_email.value
  bot_password  = data.aws_ssm_parameter.clickbait_bot_password.value
  bot_version   = "0.1.0"
  function_name = "clickbait_bot"
  mastodon_url  = "https://tavern.antinet.work"
}
