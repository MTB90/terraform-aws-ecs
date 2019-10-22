from unittest.mock import create_autospec, Mock, call

import pytest

from photorec.repository.photo import RepoPhoto
from photorec.services.image import ServiceImage, DataImageJpeg
from photorec.services.random import ServiceRandom
from photorec.services.storage import ServiceStorageS3
from photorec.use_cases.photos.upload_photo import UploadPhotoCommand


@pytest.fixture
def repo_photo():
    return create_autospec(RepoPhoto, instance=True)


@pytest.fixture()
def service_storage():
    return create_autospec(ServiceStorageS3, instance=True)


@pytest.fixture()
def service_image():
    return create_autospec(ServiceImage, instance=True)


def test_given_nickname_photo_when_upload_new_then_update_db_and_store_photo_thumb(
        repo_photo, service_storage, service_image):
    photo = create_autospec(DataImageJpeg, instance=True)
    photo.bytes.return_value = bytes(1024)

    photo_name = 'caff55d9-2054-42dd-b32e-b5440f6e45b1.jpeg'

    service_storage.generate_key.return_value = photo_name
    service_image.load.return_value = photo

    command = UploadPhotoCommand(
        repo__photo=repo_photo,
        service__storage=service_storage,
        service__image=service_image,
        validator__photo=Mock()
    )

    command.execute(nickname='nickname', data=Mock())

    repo_photo.add.assert_called_once_with(item={
        'nickname': 'nickname',
        'photo': photo_name,
        'thumbnail': f'thumbnail/{photo_name}'
    })

    service_storage.put.assert_has_calls([
        call(key=photo_name, data=photo.bytes())
    ])
