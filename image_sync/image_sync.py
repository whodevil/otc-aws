# import boto3
import uuid
import json


def handler(event, context):
    print("event: " + json.dumps(event))
    print("context: " + json.dumps(context))
    # dynamodb = boto3.client('dynamodb')
    # s3 = boto3.client('s3')
    s3key = uuid.uuid4()
    print("s3key: " + s3key)
    return {"message": "Hello, World!"}
