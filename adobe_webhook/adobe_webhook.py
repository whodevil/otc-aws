import boto3


def handler(event, context):
    print('event: ' + event)
    print('context: ' + context)
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName='ImageSyncJobQueue')
    print(queue)
    queue.send_message(MessageBody='testing testing 123')
    return {"message": "Hello, World!"}
