from ..base import BaseCQ


class UploadPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__photo,
                 service__storage, service__image, service__random):

        self._photo_repo = repo__photo
        self._photo_validator = validator__photo
        self._storage_service = service__storage
        self._image_service = service__image
        self._random_service = service__random

    def execute(self, nickname: str, data):
        photo = self._image_service.load(data)
        self._photo_validator.validate_uploaded_photo_data(photo=photo)

        photo_key = self._save_image(photo)
        thumb = self._image_service.resize(photo)
        thumb_key = self._save_image(thumb)

        item = {
            'nickname': nickname,
            'photo': photo_key,
            'thumb': thumb_key,
            'uuid': self._random_service.generate_uuid4()
        }

        self._photo_repo.add(item=item)

    def _save_image(self, image) -> str:
        image_key = self._storage_service.generate_key()
        self._storage_service.put(key=image_key, data=image.bytes())
        return image_key
