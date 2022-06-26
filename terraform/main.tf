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

resource "aws_ssm_parameter" "gpu_bot_email" {
  name        = "GPU_BOT_EMAIL"
  description = ""
  type        = "String"
  value       = var.GPU_BOT_EMAIL
}

resource "aws_ssm_parameter" "gpu_bot_password" {
  name        = "GPU_BOT_PASSWORD"
  description = ""
  type        = "SecureString"
  value       = var.GPU_BOT_PASSWORD
}

module "gpu_bot" {
  source      = "./modules/bot_lambda"
  source_file = "../bots/gpu_bot/main.py"

  bot_email     = aws_ssm_parameter.gpu_bot_email.value
  bot_password  = aws_ssm_parameter.gpu_bot_password.value
  bot_version   = "0.1.0"
  function_name = "gpu_bot"
  mastodon_url  = "https://tavern.antinet.work"
}
