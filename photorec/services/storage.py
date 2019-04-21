import boto3


class ServiceStorageS3:
    def __init__(self, config, service__random):
        self._config = config
        self._random_service = service__random
        self._s3_client = boto3.client('s3')

    def delete(self, key: str):
        pass

    def put(self, key: str, data):
        self._s3_client.put_object(
            Bucket=self._config.STORAGE,
            Key=key,
            Body=data,
            ContentType='image/jpeg'
        )

    def generate_key(self):
        uuid4 = self._random_service.generate_uuid4()
        return f"{uuid4}.jpeg"

    def get_signed_url(self, key: str):
        url = self._s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': self._config.STORAGE, 'Key': key})

        return url
