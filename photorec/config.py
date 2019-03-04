import os


class ConfigLoad(type):
    """Meta class configuration."""
    ENV_ATTRS = [
        'BASE_URL',
        'AWS_REGION',
        'COGNITO_POOL_ID',
        'COGNITO_CLIENT_ID',
        'COGNITO_CLIENT_SECRET',
        'COGNITO_DOMAIN',
        'SECRET_KEY'
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


class ProdConfig(Config):
    """Production configuration."""
    ENV = 'prod'
    DEBUG = False


class DevConfig(Config):
    """Development configuration."""
    ENV = 'dev'
    DEBUG = True
    DEFAULT_ENV = 'dev'
