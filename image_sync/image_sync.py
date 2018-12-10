import boto3


def handler(event, context):
    print(event)
    dynamodb = boto3.client('dynamodb')
    s3 = boto3.client('s3')
    return { "message": "Hello, World!" }
