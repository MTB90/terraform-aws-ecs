import socket
import logging

from flask import Blueprint, render_template, jsonify
from use_cases.factories import cq_factory
from use_cases.tag.get_all_tags import GetAllTagsQuery


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
    use_case = cq_factory.get(GetAllTagsQuery)
    response = use_case.execute()
    return render_template("tags.html", tags=response)


@blueprint.route('/tags/<name>')
def tag(name):
    """All tags sorted by popularity"""

    return name


@blueprint.route('/health')
def health():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })
