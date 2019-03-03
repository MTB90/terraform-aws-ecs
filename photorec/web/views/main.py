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


@blueprint.route('/top')
def top():
    """Top 100 photos"""
    return render_template("top.html")


@blueprint.route('/tags')
def tags():
    """All tags sorted by popularity"""

    return render_template("tags.html")


@blueprint.route('/health')
def health():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })
