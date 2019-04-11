from ..base import BaseCQ
from typing import Dict


class DeleteUserPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__nickname, service__storage):
        self._photo_repo = repo__photo
        self._nickname_validator = validator__nickname
        self._storage_service = service__storage

    def execute(self, request: Dict=None):
        nickname = request.get('nickname')
        uuid = request.get('uuid')

        self._nickname_validator.validate(nickname=nickname)
        photo = self._photo_repo.get(request)

        if photo is not None:
            self._photo_repo.delete(key={'nickname': nickname, 'uuid': uuid})
            self._storage_service.delete(key=photo['thumb'])
            self._storage_service.delete(key=photo['photo'])
