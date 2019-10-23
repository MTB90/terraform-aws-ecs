from .base import BaseCQ


class CreateThumbnail(BaseCQ):
    def __init__(self,  service__storage, service__image):
        self._storage_service = service__storage
        self._image_service = service__image

    def execute(self, photo_key: str):
        data = self._storage_service.get(photo_key)

        photo = self._image_service.load(data)
        thumbnail = self._image_service.resize(photo)

        thumbnail_key = photo_key.replace("photo", "thumbnail")
        self._storage_service.put(key=thumbnail_key, data=thumbnail.bytes())
