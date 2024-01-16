variable "access_key" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "endpoint" {
  description = "SNS topic subscription endpoint"
}

variable "account_id" {
  sensitive   = true
  description = "My account id"
}

variable "topic_name" {
  default = "my_sns_topic"
}

variable "user_name" {
  type = string
}
