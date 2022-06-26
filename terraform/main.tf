locals {
  source_dir = "../bots/gpu_bot"
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

module "gpu_bot" {
  source = "./modules/bot_lambda"
  source_file   = "../bots/gpu_bot"


  bot_email     = var.MASTODON_EMAIL
  bot_password  = var.MASTODON_PASSWORD
  bot_version   = 0.1.0
  function_name = "gpu_bot"

  environment {
    variables = {
      "BESTBUY_API_KEY" : var.BESTBUY_API_KEY
    }
  }
}