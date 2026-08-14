# Deployment Guide

This project provisions an AWS serverless data pipeline. Authenticate using an approved AWS credential mechanism such as AWS IAM Identity Center, a workload role, or a CI identity. The Terraform configuration deliberately does not accept static access keys.

```bash
cp terraform.tfvars.example terraform.tfvars
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
```

Review the plan in a disposable account before applying. Confirm Kinesis, Lambda, S3, Glue, and Athena resource names, retention choices, and IAM permissions match your organisation's policy. Run `terraform destroy` only after confirming that no data that must be retained is stored in the target resources.
