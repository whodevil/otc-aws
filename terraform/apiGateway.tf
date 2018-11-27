resource "aws_api_gateway_rest_api" "otc_api" {
  name        = "OTCApi"
  description = "the rest api for off the cob"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.otc_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.otc_api.root_resource_id}"
//TODO pick a proper path
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "adobe_webhook_proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.otc_api.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
//TODO use authorization once real functionality is added.
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "adobe_webhook" {
  rest_api_id = "${aws_api_gateway_rest_api.otc_api.id}"
  resource_id = "${aws_api_gateway_method.adobe_webhook_proxy.resource_id}"
  http_method = "${aws_api_gateway_method.adobe_webhook_proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.adobe_webhook.invoke_arn}"
}


