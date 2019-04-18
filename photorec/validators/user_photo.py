import os
from common.errors import BadRequestError


class UploadPhotoNoDataError(BadRequestError):
    def __init__(self, code=400, message=''):
        super().__init__(code=code, message=message)


class PhotoNotFoundError(BadRequestError):
    def __init__(self, code=400, message=''):
        super().__init__(code=code, message=message)


class ValidatorUserPhoto:
    MAX_SIZE = 10240
    MIN_SIZE = 300

    @staticmethod
    def validate_removed_photo(removed_photo):
        if removed_photo is None:
            raise PhotoNotFoundError()

    @staticmethod
    def validate_uploaded_photo_size(uploaded_photo):
        uploaded_photo.seek(0, os.SEEK_END)
        file_length = uploaded_photo.tell()
        pass
