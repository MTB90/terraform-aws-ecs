import logging
import flask_login
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileRequired
from flask import Blueprint, render_template

from use_cases.factories import cq_factory
from use_cases.photos.get_user_photos import GetUserPhotosQuery
from use_cases.photos.upload_user_photo import UploadUserPhotoCommand

blueprint = Blueprint('myphotos', __name__)
log = logging.getLogger(__name__)


# FlaskForm set up
class PhotoForm(FlaskForm):
    """flask_wtf form class the file upload"""
    photo = FileField('image', validators=[
        FileRequired()
    ])


@blueprint.route("/", methods=('GET', 'POST'))
@flask_login.login_required
def myphotos():
    form = PhotoForm()
    user_nickname = flask_login.current_user.nickname

    if form.validate_on_submit():
        upload_command = cq_factory.get(UploadUserPhotoCommand)
        upload_command.execute({
            'data': form.photo.data,
            'user_nickname': user_nickname
        })

    query_photos = cq_factory.get(GetUserPhotosQuery)
    photos = query_photos.execute({
        'user_nickname': user_nickname
    })

    return render_template("myphotos.html", form=form, photos=photos)

