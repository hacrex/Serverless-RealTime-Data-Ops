variable "service_name" {
  description = "Service name"
  type        = "string"
}

variable "workspace" {
  description = "terraform workspace"
  type        = "string"
}

variable "aws_account_id" {
  description = "aws_account_id"
  type        = "string"
}

variable "region" {
  description = "region"
  type        = "string"
}

variable "apigw_method" {
  description = "apigw_method"
  type        = "string"
}

variable "s3_buffer_size" {
  description = "s3_buffer_size"
  type        = "string"
}

variable "s3_buffer_interval" {
  description = "s3_buffer_interval"
  type        = "string"
}

variable "columns" {
  description = "columns"
  type        = "map"
}

variable "lambda_timeout_seconds" {
  type        = number
  default     = 15
  description = "Maximum API intake execution time in seconds."
}

variable "lambda_memory_mb" {
  type        = number
  default     = 256
  description = "Memory assigned to the event-intake Lambda."
}

variable "lambda_reserved_concurrency" {
  type        = number
  default     = 5
  description = "Concurrency cap that protects downstream delivery during bursts."
}

variable "log_retention_days" {
  type        = number
  default     = 14
  description = "CloudWatch log retention period for the intake Lambda."
}
