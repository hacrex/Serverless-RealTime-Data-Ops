# Portfolio Notes

## My focus

I use this repository to discuss decoupled ingestion, backpressure, retry behaviour, duplicate-event handling, schema evolution, and the cost implications of S3/Glue/Athena analytics.

## Evidence I can show

- `main.tf` for credential-safe provider configuration and variable-driven inputs.
- `modules/data-pipeline/` for the API, stream, Lambda, storage, catalog, and query components.
- `terraform.tfvars.example` and `docs/DEPLOYMENT_GUIDE.md` for plan-first execution.

## Known boundary

This is a reference pipeline. I would only claim throughput, cost, latency, or recovery objectives after executing load tests and collecting measurements in my own AWS environment.
