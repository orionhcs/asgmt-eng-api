import json
import logging


def handler(event, context):
    logging.info(f'function called with: {event}')
    logging.info(f'function called with: {context}')
    return {
        'statusCode': 200,
        'body': json.dumps(event)
    }
