import boto3


class ServiceRekognition:
    def __init__(self, config):
        self._service_name = 'rekognition'
        self._config = config

        self._rekognition_client = boto3.client(
            service_name=self._service_name,
            endpoint_url=config.AWS_ENDPOINTS.get(self._service_name)
        )

    def detect_tag(self, photo_key):
        response = self._rekognition_client.detect_labels(
            Image={'S3Object': {'Bucket': self._config.FILE_STORAGE, 'Name': photo_key}},
            MaxLabels=1
        )

        return response['Labels'][0]['Name']
