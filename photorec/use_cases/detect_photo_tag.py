from .base import BaseCQ


class DetectPhotoTag(BaseCQ):
    def __init__(self, repo__photo, repo__tag, service__rekognition):
        self._photo_repo = repo__photo
        self._tag_repo = repo__tag
        self._rekognition_service = service__rekognition

    def execute(self, photo_key):
        tag = self._rekognition_service.detect_tag(photo_key)

        self._tag_repo.add({'tag': tag})
        self._photo_repo.update_tag(item={'photo': photo_key, 'tag': tag})
        return tag
