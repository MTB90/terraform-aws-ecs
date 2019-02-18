import logging
from flask import Flask
from flask_debugtoolbar import DebugToolbarExtension


from web.views import auth, main
log = logging.getLogger(__name__)


def create_web_app(config_object):
    """
    Create new web application with selected config

    :param config_object: Object config for app
    :return: Web application
    """
    app = Flask(__name__)
    app.config.from_object(config_object)

    if app.debug:
        _ = DebugToolbarExtension(app)

    app.register_blueprint(main.blueprint)
    app.register_blueprint(auth.blueprint)
    return app
