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

resource "aws_iam_role_policy" "adobe_webhook_logging" {
  role = "${aws_iam_role.adobe_webhook_role.name}"
  name = "AdobeWebHookLoggingPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Action": ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
       "Effect": "Allow",
       "Resource": ["*"]
    }
  ]
}
EOF
}

module "adobe_webhook" {
  source = "./lambda"
  name = "adobe_webhook"
  role = "${aws_iam_role.adobe_webhook_role.arn}"
}

resource "aws_lambda_permission" "adobe_webhook" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.adobe_webhook.arn}"
  principal     = "apigateway.amazonaws.com"

  # https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_deployment.otc_api.execution_arn}/*"
}
