import os


class ConfigLoad(type):
    """Meta class configuration."""
    ENV_ATTRS = [
        'AWS_REGION',
        'AWS_COGNITO_POOL_ID',
        'AWS_COGNITO_CLIENT_ID',
        'AWS_COGNITO_CLIENT_SECRET',
        'AWS_COGNITO_DOMAIN',
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


class ProdConfig(Config):
    """Production configuration."""
    ENV = 'prod'
    DEBUG = False


class LocalConfig(Config):
    """Test configuration."""
    DEFAULT_ENV = 'local'
    AWS_ENDPOINTS = {
        's3': "http://127.0.0.1:4572",
        'dynamodb': "http://127.0.0.1:4569"
    }


class DevConfig(LocalConfig):
    """Dev configuration."""
    DEFAULT_ENV = 'dev'
    DEBUG = True


def get_config():
    if os.getenv("LOCAL", False):
        return LocalConfig

    if os.getenv('DEBUG', False):
        return DevConfig

    return ProdConfig
