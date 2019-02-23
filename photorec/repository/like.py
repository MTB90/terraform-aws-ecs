from typing import Dict
from .base import RepoBase


class RepoLikes(RepoBase):
    REQUIRED_KEYS = ['thumb', 'submniter']

    def __init__(self, db):
        self._likes = db.Table('photorec-dynamodb-likes')

    @property
    def table(self):
        return self._likes

    def add(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)

    def delete(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)

    def get(self, key: Dict)-> Dict:
        pass
