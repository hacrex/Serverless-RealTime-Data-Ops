resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.service_name}-${var.workspace}-lambda-errors"
  alarm_description   = "The intake Lambda returned one or more errors. Attach an approved notification action before production use."
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  actions_enabled     = false

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.service_name}-${var.workspace}-lambda-throttles"
  alarm_description   = "The reserved Lambda concurrency has been exhausted. Attach an approved notification action before production use."
  namespace           = "AWS/Lambda"
  metric_name         = "Throttles"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  actions_enabled     = false

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}
