import socket
import logging

from flask import Blueprint, render_template, jsonify
from repository.tag import RepoTag
from repository.photo import RepoPhoto

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
    repo = RepoPhoto(db)
    use_case = us.TopPhotos(repo)
    res = use_case.execute()
    return render_template("top.html", top=res)


@blueprint.route('/tags')
def tags():
    """All tags sorted by popularity"""
    repo = RepoTag(db)
    use_case = us.ListTags(repo)
    res = use_case.execute()
    return render_template("tags.html", tags=res)


@blueprint.route('/health')
def health():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })
