resource "aws_iam_role" "adobe_webhook_role" {
  name = "AdobeWebhookRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "adobe_webhook" {
  function_name = "AdobeWebhook"
  handler = "info.offthecob.adobe.webhook.Webhook::handleRequest"
  role = "${aws_iam_role.adobe_webhook_role.arn}"
  runtime = "java8"
  description = "Handles adobe events for published images"
  filename = "${path.module}../adobe-webhook/build/distributions/adobe-webhook.zip"
}
