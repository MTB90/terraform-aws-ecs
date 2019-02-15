import logging
import settings
from flask import Flask

from views import auth, main
log = logging.getLogger(__name__)


def create_app(config_object=settings.DevConfig):
    """
    Create new web application with selected config

    :param config_object: Object config for app
    :return: Web application
    """
    app = Flask(__name__)
    app.config.from_object(config_object)
    app.register_blueprint(main.blueprint)
    app.register_blueprint(auth.blueprint)
    return app


if __name__ == '__main__':
    app = create_app(settings.DevConfig)
    app.run()
