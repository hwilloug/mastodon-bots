variable "BESTBUY_API_KEY" {
  type        = string
  default     = ""
  description = "Key for the Best Buy API"
}

variable "bot_email" {
    type        = string
    default     = ""
    description = "Email of bot that will post the toot"
}

variable "bot_password" {
    type        = string
    default     = ""
    description = "Password of bot that will post the toot"
}

variable "bot_version" {
    type        = string
    default     = "0.0.1"
    description = "Version of bot"
}

variable "cron_schedule" {
    type        = string
    default     = "0 12 * * ? *"
    description = "Cron schedule to run the lambda on"
}

variable "function_name" {
    type        = string
    default     = "0.0.1"
    description = "Name of the lambda function"
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

variable "mastodon_url" {
  type        = string
  default     = ""
  description = "Mastodon URL"
}

variable "source_file" {
    type        = string
    default     = ""
    description = "main.py source code path"
}