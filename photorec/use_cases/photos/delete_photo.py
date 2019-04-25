from ..base import BaseCQ


class DeletePhotoCommand(BaseCQ):
    def __init__(self, repo__photo, validator__nickname, validator__photo, service__storage):
        self._photo_repo = repo__photo
        self._nickname_validator = validator__nickname
        self._photo_validator = validator__photo
        self._storage_service = service__storage

    def execute(self, nickname: str, uuid: str):
        self._nickname_validator.validate(nickname=nickname)
        key = {'nickname': nickname, 'uuid': uuid}

        photo = self._photo_repo.get(key=key)
        self._photo_validator.validate_removed_photo(removed_photo=photo)

        self._photo_repo.delete(key=key)
        self._storage_service.delete(key=photo['thumb'])
        self._storage_service.delete(key=photo['photo'])
