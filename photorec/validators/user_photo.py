from common.errors import BadRequestError


class UploadPhotoNoDataError(BadRequestError):
    def __init__(self, code=400, message=''):
        super().__init__(code=code, message=message)


class UploadPhotoDataSizeError(BadRequestError):
    def __init__(self, code=400, message=''):
        super().__init__(code=code, message=message)


class PhotoNotFoundError(BadRequestError):
    def __init__(self, code=400, message=''):
        super().__init__(code=code, message=message)


class ValidatorUserPhoto:
    KB = 1024
    MB = 1024 * KB

    MIN_SIZE = 300 * KB
    MAX_SIZE = 5 * MB

    @staticmethod
    def validate_removed_photo(removed_photo):
        if removed_photo is None:
            raise PhotoNotFoundError()

    @staticmethod
    def validate_uploaded_photo_data(photo):
        if not photo:
            raise UploadPhotoNoDataError()

        size = photo.size
        if size > ValidatorUserPhoto.MAX_SIZE:
            raise UploadPhotoDataSizeError(message="Size of photo can't be greater than 5MB")

        if size < ValidatorUserPhoto.MIN_SIZE:
            raise UploadPhotoDataSizeError(message="Size of photo should be at least 300KB")
