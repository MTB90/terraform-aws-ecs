import os


class ConfigLoad(type):
    """Meta class configuration."""
    ENV_ATTRS = [
        'REGION',
        'AUTH_URL',
        'AUTH_JWKS_URL',
        'AUTH_CLIENT_ID',
        'AUTH_CLIENT_SECRET',
        'BASE_URL',
        'SECRET_KEY',
        'DATABASE',
        'STORAGE'
    ]

    def __new__(mcs, name, bases, attrs):
        default_value = attrs.get('DEFAULT_ENV')
        env_attrs = {}

        for attr in mcs.ENV_ATTRS:
            env_attrs[attr] = os.getenv(attr, default_value)
        attrs.update(env_attrs)

        return super().__new__(mcs, name, bases, attrs)


class Config(metaclass=ConfigLoad):
    """Base class configuration."""
    DEFAULT_ENV = None
    HOST = "0.0.0.0"
    PORT = "8080"
    AWS_ENDPOINTS = {}


class DefaultConfig(Config):
    """Default configuration."""
    ENV = 'prod'
    DEBUG = False


class LocalConfig(Config):
    """Local configuration."""
    DEFAULT_ENV = 'photorec-local'
    AWS_ENDPOINTS = {
        's3': "http://127.0.0.1:4572",
        'dynamodb': "http://127.0.0.1:4569"
    }


def get_config():
    config = DefaultConfig

    if os.getenv("LOCAL", False):
        config = LocalConfig

    config.DEBUG = bool(os.getenv('DEBUG', False))
    return config
