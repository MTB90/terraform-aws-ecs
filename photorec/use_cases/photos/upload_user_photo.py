from ..base import BaseCQ


class UploadUserPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__user_photo, service__storage, service__image):
        self._photo_repo = repo__photo
        self._user_photo_validator = validator__user_photo
        self._storage_service = service__storage
        self._image_service = service__image

    def execute(self, nickname: str, data):
        image = self._image_service.load(data)
        self._user_photo_validator.validate_uploaded_photo_data(image=image)
        return []
