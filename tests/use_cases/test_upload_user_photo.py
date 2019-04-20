import pytest
from unittest.mock import create_autospec, Mock

from photorec.repository.photo import RepoPhoto
from photorec.services.storage import ServiceStorageS3


@pytest.fixture
def repo_photo():
    return create_autospec(RepoPhoto, instance=True)


@pytest.fixture()
def service_storage():
    return create_autospec(ServiceStorageS3, instance=True)


@pytest.fixture()
def file_image():
    file = Mock()
    file.read.return_value = bytearray(1024 * 1024)
    return file
