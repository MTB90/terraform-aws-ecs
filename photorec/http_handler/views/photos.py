import logging
import flask_login
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileRequired
from flask import Blueprint, render_template, redirect, url_for

from use_cases.factories import cq_factory
from use_cases.photos.get_photos import GetPhotosQuery
from use_cases.photos.upload_photo import UploadPhotoCommand
from use_cases.photos.delete_photo import DeletePhotoCommand

blueprint = Blueprint('myphotos', __name__)
log = logging.getLogger(__name__)


# FlaskForm set up
class PhotoForm(FlaskForm):
    """flask_wtf form class the file upload"""
    photo = FileField('image', validators=[
        FileRequired()
    ])


@blueprint.route("/", methods=('GET', 'POST'))
#@flask_login.login_required
def myphotos():
    """Add/list photo route"""
    form = PhotoForm()
    user_nickname = 'mati'

    if form.validate_on_submit():
        upload_command = cq_factory.get(UploadPhotoCommand)
        upload_command.execute(nickname=user_nickname, data=form.photo.data)

    photos_query = cq_factory.get(GetPhotosQuery)
    photos = photos_query.execute(query={'nickname': user_nickname})

    return render_template("myphotos.html", form=form, photos=photos)


@blueprint.route("/delete/<path:photo>")
#@flask_login.login_required
def myphotos_delete(photo):
    """Delete photo route"""
    user_nickname = 'mati'
    photos_delete = cq_factory.get(DeletePhotoCommand)
    photos_delete.execute(nickname=user_nickname, photo=photo)

    return redirect(url_for("myphotos.myphotos"))
