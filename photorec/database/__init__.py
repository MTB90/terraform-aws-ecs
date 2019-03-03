import boto3


def create_db(config):
    return boto3.resource('dynamodb', region_name=config.AWS_REGION)
