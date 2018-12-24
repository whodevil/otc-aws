import boto3
import uuid
import json
import pprint
import aws_lambda_logging
from boto3_type_annotations.s3 import Client as S3Client
from boto3_type_annotations.dynamodb import Client as DynamodbClient
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    aws_lambda_logging.setup(level="INFO")
    logger.info("event: " + json.dumps(event))
    pp = pprint.PrettyPrinter(indent=4)
    logger.info(pp.pprint(context))
    dynamodb: DynamodbClient = boto3.client("dynamodb")
    s3: S3Client = boto3.client("s3")
    s3key = uuid.uuid4()
    logger.info("buckets")
    logger.info(pp.pprint(s3.list_buckets()))
    logger.info("dynamodb")
    logger.info(pp.pprint(dynamodb.list_tables()))
    logger.info("s3key: " + s3key)
    return {"message": "Hello, World!"}
