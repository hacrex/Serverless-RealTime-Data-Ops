terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.service_name
      Environment = var.workspace
      ManagedBy   = "Terraform"
    }
  }
}

module "data_pipeline" {
  source = "./modules/data-pipeline"

  workspace          = var.workspace
  aws_account_id     = var.aws_account_id
  region             = var.region
  service_name       = var.service_name
  apigw_method       = var.apigw_method
  s3_buffer_size     = var.s3_buffer_size
  s3_buffer_interval = var.s3_buffer_interval
  columns                     = var.columns
  lambda_timeout_seconds      = var.lambda_timeout_seconds
  lambda_memory_mb            = var.lambda_memory_mb
  lambda_reserved_concurrency = var.lambda_reserved_concurrency
  log_retention_days          = var.log_retention_days
}

variable "region" { type = string }
variable "aws_account_id" { type = string }
variable "workspace" {
  type    = string
  default = "dev"
}

variable "service_name" {
  type    = string
  default = "realtime-data-ops"
}

variable "apigw_method" {
  type    = string
  default = "POST"
}

variable "s3_buffer_size" {
  type    = string
  default = "5"
}

variable "s3_buffer_interval" {
  type    = string
  default = "300"
}
variable "columns" {
  type = map(string)
  default = {
    id         = "int"
    type       = "string"
    status     = "int"
    created_at = "timestamp"
  }
}


variable "lambda_timeout_seconds" {
  type    = number
  default = 15
}

variable "lambda_memory_mb" {
  type    = number
  default = 256
}

variable "lambda_reserved_concurrency" {
  type    = number
  default = 5
}

variable "log_retention_days" {
  type    = number
  default = 14
}
