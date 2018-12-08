variable "aws_api_gateway_rest_api_execution_arn" {}
variable "lambda_invoke_arn" {}
variable "lambda_name" {}
variable "path" {}
variable "aws_api_gateway_resource_id" {}
variable "aws_api_gateway_rest_api_id" {}

variable "authorization" {
  default = "NONE"
}

variable "http_method" {
  default = "GET"
}

resource "aws_api_gateway_method" "request_method" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${aws_api_gateway_method.request_method.http_method}"
  type = "AWS"
  integration_http_method = "POST"
  uri = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${aws_api_gateway_integration.request_method_integration.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${aws_api_gateway_method_response.response_method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_method.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "${var.lambda_name}"
  statement_id = "AllowExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"

  # https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${var.aws_api_gateway_rest_api_execution_arn}/*/${var.http_method}${var.path}"
}

output "http_method" {
  value = "${aws_api_gateway_integration_response.response_method_integration.http_method}"
}