from typing import Dict
from .base import RepoBase


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    def __init__(self, db, config):
        super().__init__(db=db, config=config)
        self._photos = db.Table(f"{self._config.DATABASE}-photos")

    @property
    def table(self):
        return self._photos

    def add(self, item: Dict):
        item['likes'] = 0
        return super().add(item=item)
