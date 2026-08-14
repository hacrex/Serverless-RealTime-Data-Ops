import base64
import json
import logging
import os
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError

LOGGER = logging.getLogger()
LOGGER.setLevel(os.getenv("LOG_LEVEL", "INFO"))
FIREHOSE = boto3.client("firehose")
STREAM_NAME = os.environ["FIREHOSE_STREAM_NAME"]


def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(body),
    }


def handler(event, context):
    if event.get("httpMethod") != "POST":
        return response(405, {"message": "Only POST is supported."})

    try:
        body = event.get("body") or "{}"
        if event.get("isBase64Encoded"):
            body = base64.b64decode(body).decode("utf-8")
        payload = json.loads(body)
    except (ValueError, UnicodeDecodeError):
        return response(400, {"message": "Request body must contain valid JSON."})

    if not isinstance(payload, dict) or not payload.get("eventId") or not payload.get("eventType"):
        return response(400, {"message": "eventId and eventType are required."})

    record = {
        "eventVersion": "1.0",
        "ingestedAt": datetime.now(timezone.utc).isoformat(),
        "payload": payload,
    }

    try:
        FIREHOSE.put_record(
            DeliveryStreamName=STREAM_NAME,
            Record={"Data": (json.dumps(record) + "\n").encode("utf-8")},
        )
    except ClientError:
        LOGGER.exception("Firehose delivery failed", extra={"event_id": payload.get("eventId")})
        return response(502, {"message": "Event intake is temporarily unavailable. Retry with the same eventId."})

    LOGGER.info("Event accepted", extra={"event_id": payload.get("eventId"), "event_type": payload.get("eventType")})
    return response(202, {"message": "Event accepted.", "eventId": payload["eventId"]})
