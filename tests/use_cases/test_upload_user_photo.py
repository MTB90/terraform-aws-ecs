import pytest
from unittest.mock import create_autospec, Mock, call

from photorec.repository.photo import RepoPhoto
from photorec.services.random import ServiceRandom
from photorec.services.storage import ServiceStorageS3
from photorec.services.image import ServiceImage, DataImageJpeg

from photorec.use_cases.photos.upload_user_photo import UploadUserPhotoCommand


@pytest.fixture
def repo_photo():
    return create_autospec(RepoPhoto, instance=True)


@pytest.fixture()
def service_storage():
    return create_autospec(ServiceStorageS3, instance=True)


@pytest.fixture()
def service_image():
    return create_autospec(ServiceImage, instance=True)


@pytest.fixture()
def service_random():
    return create_autospec(ServiceRandom, instance=True)


def test_given_nickname_photo_when_upload_new_then_update_db_and_store_photo_thumb(
        repo_photo, service_storage, service_image, service_random):

    photo = create_autospec(DataImageJpeg, instance=True)
    photo.bytes.return_value = bytes(1024)

    thumb = create_autospec(DataImageJpeg, instance=True)
    thumb.bytes.return_value = bytes(100)

    images = [
        'caff55d9-2054-42dd-b32e-b5440f6e45b1.jpeg',
        '3ce73f30-fe67-45f9-a8d0-ab8d1d9ea617.jpeg'
    ]

    service_storage.generate_key.side_effect = images

    service_image.load.return_value = photo
    service_image.resize.return_value = thumb

    uuid4 = '3614612b-20fe-412e-b65d-6ad7211e438d'
    service_random.generate_uuid4.return_value = uuid4

    command = UploadUserPhotoCommand(
        repo__photo=repo_photo,
        service__storage=service_storage,
        service__image=service_image,
        service__random=service_random,
        validator__user_photo=Mock()
    )

    command.execute(nickname='nickname', item=Mock())

    service_storage.put.assert_has_calls([
        call(key=images[0], data=photo.bytes()),
        call(key=images[1], data=thumb.bytes())
    ])

    repo_photo.add.assert_called_once_with(item={
        'nickname': 'nickname',
        'uuid': uuid4,
        'photo': images[0],
        'thumb': images[1]
    })
