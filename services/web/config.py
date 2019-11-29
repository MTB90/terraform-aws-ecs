import os

from photorec.services.ssm import ServiceSSM


class ConfigLoad(type):
    """Meta class configuration."""
    ENV_ATTRS = [
        'REGION',
        'PROJECT',
        'SERVICE',
        'ENVIRONMENT'
    ]

    def __new__(mcs, name, bases, attrs):
        env_attrs = {attr: os.getenv(attr, None) for attr in mcs.ENV_ATTRS}
        attrs.update(env_attrs)
        return super().__new__(mcs, name, bases, attrs)


class DefaultConfig(metaclass=ConfigLoad):
    """Default configuration."""
    HOST = "0.0.0.0"
    PORT = "8080"
    AWS_ENDPOINTS = {}


class LocalConfig(metaclass=ConfigLoad):
    """Local configuration."""
    HOST = "0.0.0.0"
    PORT = "8080"
    AWS_ENDPOINTS = {
        's3': "http://127.0.0.1:4572",
        'ssm': "http://127.0.0.1:4583",
        'dynamodb': "http://127.0.0.1:4569"
    }

    DATABASE = "photorec-local"
    FILE_STORAGE = "photorec-local"


def get_config():
    if os.getenv("LOCAL", False):
        config = LocalConfig
    else:
        config = DefaultConfig
        ssm = ServiceSSM(config)
        prefix = f"{config.PROJECT}-{config.ENVIRONMENT}"

        config.URL = ssm.get_parameter(f"{prefix}-web-url")
        config.AUTH_URL = ssm.get_parameter(f"{prefix}-auth-url")
        config.AUTH_JWKS_URL = ssm.get_parameter(f"{prefix}-auth-jwks-url")

        config.SECRET_KEY = ssm.get_parameter(f"{prefix}-web-secret-key", True)
        config.AUTH_CLIENT_ID = ssm.get_parameter(f"{prefix}-auth-client-id", True)
        config.AUTH_CLIENT_SECRET = ssm.get_parameter(f"{prefix}-auth-client-secret", True)

        config.DATABASE = ssm.get_parameter(f"{prefix}-database-name")
        config.FILE_STORAGE = ssm.get_parameter(f"{prefix}-file-storage")

    config.DEBUG = bool(os.getenv('DEBUG', False))
    return config
