import boto3


def handler(event, context):
    print(event)
    sqs = boto3.resource('sqs')
    """ :type: pyboto3.sqs """
    queue = sqs.get_queue_by_name(QueueName='ImageSyncJobQueue')
    print(queue.url)
    return {"message": "Hello, World!"}
