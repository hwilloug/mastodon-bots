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

variable "function_name" {
    type        = string
    default     = "0.0.1"
    description = "Name of the lambda function"
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

variable "source_file" {
    type        = string
    default     = ""
    description = "main.py source code path"
}