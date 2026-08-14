data "template_file" "lambda_tpl" {
  template = file("${path.module}/index.py.tpl")

  vars = {
    firehose = aws_kinesis_firehose_delivery_stream.data_stream.name
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = data.template_file.lambda_tpl.rendered
    filename = "index.py"
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.service_name}-${var.workspace}"
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "lambda" {
  filename                       = data.archive_file.lambda_zip.output_path
  function_name                  = "${var.service_name}-${var.workspace}"
  role                           = aws_iam_role.lambda.arn
  handler                        = "index.handler"
  runtime                        = "python3.12"
  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256
  timeout                        = var.lambda_timeout_seconds
  memory_size                    = var.lambda_memory_mb
  reserved_concurrent_executions = var.lambda_reserved_concurrency

  environment {
    variables = {
      FIREHOSE_STREAM_NAME = aws_kinesis_firehose_delivery_stream.data_stream.name
      LOG_LEVEL            = "INFO"
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda]
}

data "aws_iam_policy_document" "assume_by_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.service_name}-${var.workspace}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_by_lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid     = "WriteFunctionLogs"
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*",
    ]
  }

  statement {
    sid     = "PutEventsToThisDeliveryStream"
    effect  = "Allow"
    actions = ["firehose:PutRecord"]
    resources = [
      aws_kinesis_firehose_delivery_stream.data_stream.arn,
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.lambda.json
}
