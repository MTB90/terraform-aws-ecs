import logging

from flask import Blueprint

blueprint = Blueprint('like', __name__)
log = logging.getLogger(__name__)


@blueprint.route("/likes", methods=['GET'])
def get_likes():
    return ''
