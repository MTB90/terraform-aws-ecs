import boto3


class ServiceSSM:
    def __init__(self, config):
        self._service_name = 'ssm'
        self._config = config

        self._ssm_client = boto3.client(
            region_name=config.REGION,
            service_name=self._service_name,
            endpoint_url=config.AWS_ENDPOINTS.get(self._service_name)
        )

    def get_parameter(self, name: str, decryption: bool = False) -> str:
        result = self._ssm_client.get_parameter(
            Name=name,
            WithDecryption=decryption
        )
        return result["Parameter"]["Value"]
