import boto3


class ServiceStorageS3:
    def __init__(self, config):
        self._config = config
        self._s3_client = boto3.client('s3')

    def delete(self, key: str):
        pass

    def put(self, file_name: str, data):
        self._s3_client.put_object(
            Bucket=self._config.S3_BUCKET,
            Key=file_name,
            Body=data,
            ContentType='image/png'
        )

    def get_signed_url(self, key: str):
        url = self._s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': self._config.S3_BUCKET, 'Key': key})

        return url
