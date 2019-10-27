import pytest
from uuid import UUID

from photorec.config import LocalConfig
from photorec.services.storage import ServiceStorageS3
from photorec.services.random import ServiceRandom
from photorec.services.image import ServiceImage


@pytest.fixture()
def service_storage():
    return ServiceStorageS3(
        config=LocalConfig,
        service__random=ServiceRandom()
    )


def test_when_generate_image_key_then_return_valid_key(service_storage):
    key = service_storage.generate_key()
    uuid4, ext = key.split(".")

    assert UUID(uuid4).version == 4
    assert ext == "jpeg"


def test_when_remove_not_existing_photo_then_return_204(service_storage):
    response = service_storage.delete(key="unknown")
    assert response == 204


def test_when_add_new_photo_then_return_200(service_storage):
    with open("../tests/fixtures/image.png", "rb") as file:
        service_image = ServiceImage()
        image = service_image.load(file)

        image_key = service_storage.generate_key()
        response = service_storage.put(key=image_key, data=image.bytes())
        assert response == 200

        response = service_storage.get(key=image_key)
        assert response is not None


def test_no_photo_then_get_signed_url_return_none(service_storage):
    photo = f"{service_storage.generate_key()}.jpg"

    response = service_storage.get_signed_url(photo)
    assert response is None
