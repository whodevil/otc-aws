resource "aws_iam_role" "image_fetcher_role" {
  name = "ImageFetcherRole"
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

resource "aws_iam_role_policy" "image_fetcher_logging" {
  role = "${aws_iam_role.image_fetcher_role.name}"
  name = "ImageFetcherLoggingPolicy"
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

module "image_fetcher_lambda" {
  source = "./lambda"
  name = "image_fetcher"
  role = "${aws_iam_role.image_fetcher_role.arn}"
}
