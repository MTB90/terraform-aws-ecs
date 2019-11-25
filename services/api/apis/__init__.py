from flask import Flask

from .v1 import likes


def create_http_app(config):
    """
    Create new http application with selected config

    :param config: Object config for app
    :return: Http application
    """
    app = Flask(__name__)
    app.config.from_object(config)

    app.register_blueprint(likes.blueprint, url_prefix="/v1")
    return app
