# Event Contract and Recovery

The intake API accepts a JSON event envelope defined in [`schemas/event-envelope.v1.json`](../schemas/event-envelope.v1.json). The Lambda requires `eventId` and `eventType`; producers should also provide `occurredAt` and `data`.

## Test the API

```bash
./scripts/send-sample-event.sh <api-url> <api-key> valid
./scripts/send-sample-event.sh <api-url> <api-key> invalid
```

The invalid request should return HTTP 400. A valid request should return HTTP 202. Retrying a request after a 502 must use the same `eventId`; downstream consumers need an idempotency strategy based on that key because delivery systems can retry.

## Failure scenario: Firehose unavailable

If the Lambda cannot put a record into Firehose, it logs the failure and returns HTTP 502 without exposing provider details. The producer should retry with bounded exponential backoff and the same event ID. Investigate Lambda `Errors`, `Throttles`, and Firehose delivery/error prefixes before increasing concurrency. The repository creates disabled-by-default CloudWatch alarms so a production environment can attach an approved notification target.

## Boundary

The JSON schema is a producer contract and a test artifact. The Lambda performs only a lightweight required-field check. Add schema enforcement, PII classification, consumer deduplication storage, and a formal data-retention policy before production use.
