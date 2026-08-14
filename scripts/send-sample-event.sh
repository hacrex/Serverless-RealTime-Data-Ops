#!/usr/bin/env bash
set -euo pipefail

API_URL="${1:?Usage: $0 <api-url> <api-key> [valid|invalid>}"
API_KEY="${2:?Usage: $0 <api-url> <api-key> [valid|invalid>}"
MODE="${3:-valid}"

if [ "$MODE" = "invalid" ]; then
  BODY='{"eventType":"order.created"}'
else
  BODY="$(cat <<'JSON'
{"eventId":"demo-001","eventType":"order.created","occurredAt":"2026-01-01T00:00:00Z","data":{"orderId":"demo-order-001","status":"created"}}
JSON
)"
fi

curl --fail-with-body --show-error --silent \
  -X POST "$API_URL" \
  -H 'content-type: application/json' \
  -H "x-api-key: $API_KEY" \
  --data "$BODY"
printf '\n'
