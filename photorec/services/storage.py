import boto3
from botocore.errorfactory import ClientError


class ServiceStorageS3:
    def __init__(self, config, service__random):
        self._service_name = 's3'
        self._config = config
        self._random_service = service__random

        self._s3_client = boto3.client(
            service_name=self._service_name,
            endpoint_url=config.AWS_ENDPOINTS.get(self._service_name)
        )

    def delete(self, key: str):
        response = self._s3_client.delete_object(
            Bucket=self._config.STORAGE,
            Key=key,
        )

        return response['ResponseMetadata']['HTTPStatusCode']

    def put(self, key: str, data):
        response = self._s3_client.put_object(
            Bucket=self._config.STORAGE,
            Key=key,
            Body=data,
            ContentType='image/jpeg'
        )

        return response['ResponseMetadata']['HTTPStatusCode']

    def generate_key(self):
        uuid4 = self._random_service.generate_uuid4()
        return f"{uuid4}.jpeg"

    def get_signed_url(self, key: str):
        try:
            self._s3_client.head_object(Bucket=self._config.STORAGE, Key=key)
            return self._s3_client.generate_presigned_url(
                'get_object',
                Params={'Bucket': self._config.STORAGE, 'Key': key}
            )
        except ClientError:
            return None
