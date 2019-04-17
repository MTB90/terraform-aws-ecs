from typing import Dict

from common.errors import ValidationError
from ..base import BaseCQ


class PhotoNotFoundError(ValidationError):
    pass


class DeleteUserPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__nickname, service__storage):
        self._photo_repo = repo__photo
        self._nickname_validator = validator__nickname
        self._storage_service = service__storage

    def execute(self, nickname: str, uuid: str):
        self._nickname_validator.validate(nickname=nickname)
        key = {'nickname': nickname, 'uuid': uuid}

        photo = self._photo_repo.get(key=key)
        if photo is not None:
            self._photo_repo.delete(key=key)
            self._storage_service.delete(key=photo['thumb'])
            self._storage_service.delete(key=photo['photo'])
        else:
            raise PhotoNotFoundError("Photo already not exist")
