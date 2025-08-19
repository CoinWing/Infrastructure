import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Lambda invoked with event: %s", event)
    
    # Simple response indicating the function was called
    response_body = {
        "message": "Lambda function executed successfully!",
        "input_event": event
    }
    
    return {
        "statusCode": 200,
        "body": json.dumps(response_body)
    }
