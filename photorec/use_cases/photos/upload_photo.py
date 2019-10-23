from ..base import BaseCQ


class UploadPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__photo, service__storage, service__image,):
        self._photo_repo = repo__photo
        self._photo_validator = validator__photo
        self._storage_service = service__storage
        self._image_service = service__image

    def execute(self, nickname: str, data):
        photo = self._image_service.load(data)
        self._photo_validator.validate_uploaded_photo_data(photo=photo)
        key = self._storage_service.generate_key()

        photo_key = f"photo/{key}"
        thumbnail_key = f"thumbnail/{key}"

        item = {
            'nickname': nickname,
            'photo': photo_key,
            'thumbnail': thumbnail_key,
        }

        self._photo_repo.add(item=item)
        self._storage_service.put(key=photo_key, data=photo.bytes())
