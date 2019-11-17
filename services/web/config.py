import os


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
