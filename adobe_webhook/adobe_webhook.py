import boto3
import json
import pprint
import aws_lambda_logging
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    aws_lambda_logging.setup(level="INFO")
    logger.info("event: " + json.dumps(event))
    pp = pprint.PrettyPrinter(indent=4)
    logger.info("context")
    logger.info(pp.pprint(context))
    sqs = boto3.resource("sqs")
    queue = sqs.get_queue_by_name(QueueName="ImageSyncJobQueue")
    logger.info(queue)
    queue.send_message(MessageBody="testing testing 123")
    return {"message": "Hello, World!"}
