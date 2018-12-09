resource "aws_iam_role" "image_sync_role" {
  name = "ImageSyncRole"
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

resource "aws_iam_role_policy" "image_sync_logging" {
  role = "${aws_iam_role.image_sync_role.name}"
  name = "ImageSyncLoggingPolicy"
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

module "image_sync_lambda" {
  source = "./lambda"
  name = "image_sync"
  role = "${aws_iam_role.image_sync_role.arn}"
}
