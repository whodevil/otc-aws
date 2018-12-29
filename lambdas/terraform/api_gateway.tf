resource "aws_api_gateway_rest_api" "otc_api" {
  name        = "OTCApi"
  description = "the rest api for off the cob"
}

resource "aws_api_gateway_deployment" "otc_api" {
  depends_on = [
    "module.adobe_webhook_api_method"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.otc_api.id}"
  stage_name  = "prod"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.otc_api.invoke_url}"
}