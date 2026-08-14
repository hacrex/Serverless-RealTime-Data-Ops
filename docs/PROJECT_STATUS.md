# Project Status

## Portfolio Scope

An AWS serverless data-pipeline reference that combines API Gateway, Kinesis, Lambda, S3, Glue, and Athena through Terraform.

## Intended Deployment Path

Copy `terraform.tfvars.example`, authenticate with short-lived AWS credentials, run `terraform plan`, and apply only in a dedicated non-production AWS account.

## Safety and Validation

This repository contains **non-production reference configuration** unless its deployment guide explicitly states otherwise. Review every Terraform plan and Kubernetes manifest in an isolated account, project, subscription, compartment, or cluster before use. Do not commit credentials, cloud access keys, API tokens, or live state files.

## What to Discuss in an Interview

Explain the architecture, the operational trade-offs, how you would validate a change, how you would roll it back, and the parts that require organisation-specific configuration.
