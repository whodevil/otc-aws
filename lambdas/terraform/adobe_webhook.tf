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

resource "aws_iam_role_policy" "adobe_webhook" {
  role = "${aws_iam_role.adobe_webhook_role.name}"
  name = "AdobeWebHookPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Action": ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
       "Effect": "Allow",
       "Resource": ["*"]
    },
    {
       "Action": ["sqs:SendMessage"],
       "Effect": "Allow",
       "Resource": ["${aws_sqs_queue.image_sync_job_queue.arn}"]
    },
    {
       "Action": ["sqs:ListQueues", "sqs:GetQueueUrl"],
       "Effect": "Allow",
       "Resource": ["*"]
    }
  ]
}
EOF
}

module "adobe_webhook_lambda" {
  source = "./lambda"
  name = "adobe_webhook"
  role = "${aws_iam_role.adobe_webhook_role.arn}"
}

resource "aws_api_gateway_resource" "adobe_webhook" {
  rest_api_id = "${aws_api_gateway_rest_api.otc_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.otc_api.root_resource_id}"
  path_part   = "webhook"
}

module "adobe_webhook_api_method" {
  source = "./api_method"

  aws_api_gateway_rest_api_execution_arn = "${aws_api_gateway_rest_api.otc_api.execution_arn}"
  aws_api_gateway_resource_id = "${aws_api_gateway_resource.adobe_webhook.id}"
  aws_api_gateway_rest_api_id = "${aws_api_gateway_rest_api.otc_api.id}"
  lambda_invoke_arn = "${module.adobe_webhook_lambda.invoke_arn}"
  lambda_name = "${module.adobe_webhook_lambda.name}"
  path = "/webhook"
}