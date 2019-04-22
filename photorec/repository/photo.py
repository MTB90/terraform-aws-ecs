from typing import Dict
from .base import RepoBase


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    def __init__(self, db):
        self._photos = db.Table(f"{self._config.DATABASE}-photos")

    @property
    def table(self):
        return self._photos

    def add(self, item: Dict):
        item['likes'] = 0
        return self.table.put_item(Item=item)
