from ..base import BaseCQ


class UploadUserPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__user_photo, service_storage):
        self._photo_repo = repo__photo
        self._user_photo_validator = validator__user_photo
        self._storage_service = service_storage

    def execute(self, nickname: str, data):
        self._user_photo_validator.validate_uploaded_photo_size(uploaded_photo=data)
        return []
