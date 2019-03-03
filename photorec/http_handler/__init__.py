import logging
from flask import Flask
from flask_debugtoolbar import DebugToolbarExtension


from http_handler.views import auth, main
log = logging.getLogger(__name__)


def create_http_app(config):
    """
    Create new http application with selected config

    :param config: Object config for app
    :return: Http application
    """
    app = Flask(config.NAME)
    app.config.from_object(config)

    if app.debug:
        _ = DebugToolbarExtension(app)

    app.register_blueprint(main.blueprint)
    app.register_blueprint(auth.blueprint)
    return app
