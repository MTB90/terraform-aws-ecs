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
        if 'DEFAULT_ENV' in attrs:
            defualt_env = attrs['DEFAULT_ENV']
            env_attrs = {}

            for attr in mcs.ENV_ATTRS:
                env_attrs[attr] = os.getenv(attr, defualt_env)
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


class DevConfig(Config):
    """Development configuration."""
    ENV = 'dev'
    DEBUG = True
    DEFAULT_ENV = 'dev'
    AWS_ENDPOINTS = {
        's3': "http://localhost:4572",
        'dynamodb': "http://localhost:4569"
    }


def get_cofnig():
    debug = os.getenv('DEBUG', False)
    if debug:
        return DevConfig
    return ProdConfig
