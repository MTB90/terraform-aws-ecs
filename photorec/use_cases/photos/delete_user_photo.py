from ..base import BaseCQ
from typing import Dict


class DeleteUserPhotoCommand(BaseCQ):
    def __init__(self, repo__photo, repo__tag):
        self._photo_repo = repo__photo
        self._tag_repo = repo__tag

    def execute(self, request: Dict=None):
        # TODO
        return self._photo_repo.delete(request)
