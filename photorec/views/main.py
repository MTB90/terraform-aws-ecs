import socket
import logging

from flask import Blueprint, render_template, jsonify

blueprint = Blueprint('main', __name__)
log = logging.getLogger(__name__)


@blueprint.route('/')
def index():
    """Homepage route"""
    host = socket.gethostname()
    return render_template("index.html", host=host)


@blueprint.route('/health')
def health_check():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })
