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

resource "aws_iam_role_policy" "image_sync" {
  role = "${aws_iam_role.image_sync_role.name}"
  name = "ImageSyncPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Action": ["logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents",
                  "sqs:ListQueues",
                  "sqs:GetQueueUrl",
                  "dynamodb:ListTables"],
       "Effect": "Allow",
       "Resource": ["*"]
    },
    {
       "Action": ["sqs:DeleteMessage",
                  "sqs:ChangeMessageVisibility",
                  "sqs:ReceiveMessage",
                  "sqs:GetQueueAttributes"],
       "Effect": "Allow",
       "Resource": ["${aws_sqs_queue.image_sync_job_queue.arn}"]
    },
    {
       "Action": ["dynamodb:GetItem",
                  "dynamodb:PutItem",
                  "dynamodb:UpdateItem"],
       "Effect": "Allow",
       "Resource": ["${aws_dynamodb_table.image_metadata.arn}",
                    "${aws_dynamodb_table.image_tag.arn}"]
    },
    {
       "Action": ["s3:PutObject"],
       "Effect": "Allow",
       "Resource": ["${aws_s3_bucket.images.arn}/*"]
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

resource "aws_lambda_event_source_mapping" "image_sync_job_queue" {
  event_source_arn = "${aws_sqs_queue.image_sync_job_queue.arn}"
  function_name    = "${module.image_sync_lambda.arn}"
}