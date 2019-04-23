from typing import Dict
from ..base import BaseCQ


class GetPhotosQuery(BaseCQ):
    def __init__(self, repo__photo, service__storage):
        self._photo_repo = repo__photo
        self._storage_service = service__storage

    def execute(self, query: Dict = None, filters: Dict = None):
        photos = self._photo_repo.list(query=query, filters=filters)

        for photo in photos:
            photo['thumb_signed_url'] = self._storage_service.get_signed_url(photo['thumb'])
            photo['photo_signed_url'] = self._storage_service.get_signed_url(photo['photo'])
        return photos
