# Serverless Real-Time Data Ops

An AWS event-ingestion path built with API Gateway, Lambda, Kinesis Data Firehose, S3, Glue, and Athena. It accepts a JSON event, adds an ingestion timestamp, and writes a compressed record to Firehose for delivery to S3.

The original starting point was [AWS Serverless Data Pipeline by Terraform](https://github.com/gnokoheat/aws-serverless-data-pipeline-by-terraform), retained under its MIT license. This copy updates the intake Lambda and its operational controls.

## Event contract

The expected envelope is in `schemas/event-envelope.v1.json`.

```bash
./scripts/send-sample-event.sh <api-url> <api-key> valid
./scripts/send-sample-event.sh <api-url> <api-key> invalid
```

A valid request returns `202`; a missing `eventId` or `eventType` returns `400`. Producers should retry a `502` with the same event ID. Consumers still need their own idempotency and data-retention design.

## Terraform

```bash
terraform init
terraform plan
```

Use a separate, non-committed variables file for AWS account settings. The Terraform module uses a current Lambda runtime, a scoped Firehose permission, encrypted/versioned S3 storage, and disabled-by-default CloudWatch alarms. Attach notification actions only after choosing the on-call destination.
