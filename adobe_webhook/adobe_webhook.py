import boto3
import json


def handler(event, context):
    print("event: " + json.dumps(event))
    print("context: " + json.dumps(context))
    sqs = boto3.resource("sqs")
    queue = sqs.get_queue_by_name(QueueName="ImageSyncJobQueue")
    print(queue)
    queue.send_message(MessageBody="testing testing 123")
    return {"message": "Hello, World!"}
