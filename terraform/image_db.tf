resource "aws_s3_bucket" "images" {
  bucket = "images.offthecob.info"
  acl = "public-read"
  tags {
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "image_tag" {
  name           = "ImageTag"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "s3key"
  range_key      = "tag"

  attribute {
    name = "tag"
    type = "S"
  }

  attribute {
    name = "s3key"
    type = "S"
  }

  tags {
    Environment = "production"
  }

  read_capacity = 0
  write_capacity = 0
}

resource "aws_dynamodb_table" "image_metadata" {
  name = "ImageMetadata"
  hash_key = "s3Key"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "s3Key"
    type = "S"
  }

  tags {
    Environment = "production"
  }

  read_capacity = 0
  write_capacity = 0
}