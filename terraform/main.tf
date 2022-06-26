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

module "gpu_bot" {
  source      = "./modules/bot_lambda"
  source_file = "../bots/gpu_bot/main.py"

  bot_email     = var.GPU_BOT_EMAIL
  bot_password  = var.GPU_BOT_PASSWORD
  bot_version   = "0.1.0"
  function_name = "gpu_bot"
  mastodon_url  = "https://tavern.antinet.work"
}