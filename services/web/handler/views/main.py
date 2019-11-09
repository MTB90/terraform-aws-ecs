import logging
import socket

from flask import Blueprint, render_template, jsonify, request

from factories import cq_factory
from photorec.use_cases.photos.get_photos import GetPhotosQuery
from photorec.use_cases.tag.get_all_tags import GetAllTagsQuery

blueprint = Blueprint('main', __name__)
log = logging.getLogger(__name__)


@blueprint.route('/')
def index():
    """Homepage route"""
    host = socket.gethostname()
    return render_template("index.html", host=host)


@blueprint.route('/top')
def top():
    """Top photos"""
    tag = request.args.get('tag')
    query = None if tag is None else {'tag': tag}

    use_case = cq_factory.get(GetAllTagsQuery)
    tags = use_case.execute()

    use_case = cq_factory.get(GetPhotosQuery)
    photos = use_case.execute(query=query)

    return render_template("top.html", tags=tags, photos=photos)


@blueprint.route('/health')
def health():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })
