import boto3


def create_db(config):
    service_name = 'dynamodb'
    return boto3.resource(
        service_name=service_name,
        region_name=config.REGION,
        endpoint_url=config.AWS_ENDPOINTS.get(service_name)
    )
