import logging
import socket

from flask import Blueprint, jsonify
from flask import Flask

blueprint = Blueprint('health', __name__)
log = logging.getLogger(__name__)


@blueprint.route('/health')
def health():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })


def create_http_app(config):
    """
    Create new http application with selected config

    :param config: Object config for app
    :return: Http application
    """
    app = Flask(__name__)
    app.config.from_object(config)

    app.register_blueprint(blueprint)
    return app
