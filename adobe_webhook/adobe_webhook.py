import boto3


def handler(event, context):
    print(event)
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName='ImageSyncJobQueue')
    return {"message": "Hello, World!"}
