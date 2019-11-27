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


def get_config():
    config = DefaultConfig
    config.DEBUG = bool(os.getenv('DEBUG', False))
    return config
