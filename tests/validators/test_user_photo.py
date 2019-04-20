import pytest
from photorec.validators.user_photo import ValidatorUserPhoto
from photorec.validators.user_photo import UploadPhotoNoDataError, UploadPhotoDataSizeError


def test_given_nickname_empty_data_when_upload_photo_then_raise():
    data = None
    with pytest.raises(UploadPhotoNoDataError):
        ValidatorUserPhoto.validate_uploaded_photo_data(data)


@pytest.mark.parametrize("data", [bytearray(1024 * 1024 * 10), bytearray(100)])
def test_given_nickname_data_when_upload_with_wrong_size_photo_then_raise(data):
    with pytest.raises(UploadPhotoDataSizeError):
        ValidatorUserPhoto.validate_uploaded_photo_data(data)


@pytest.mark.parametrize("data", [
    bytearray(300 * 1024),
    bytearray(2 * 1024 * 1024),
    bytearray(5 * 1024 * 1024)
])
def test_given_nickname_data_when_upload_with_correct_size_photo_then_no_raise(data):
    try:
        ValidatorUserPhoto.validate_uploaded_photo_data(data)
    except Exception as e:
        pytest.fail(f"No raise expected {e.message}")
