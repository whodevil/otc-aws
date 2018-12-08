variable "name" {
  description = "The name of the lambda"
}

variable "role" {
  description = "The role of the lambda"
}

resource "aws_lambda_function" "lambda" {
  filename      = "../builddir/${var.name}.zip"
  function_name = "${var.name}"
  role          = "${var.role}"
  handler       = "${var.name}.handler"
  runtime       = "python3.7"
}

output "name" {
  value = "${aws_lambda_function.lambda.function_name}"
}
