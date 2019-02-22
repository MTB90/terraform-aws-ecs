from typing import Dict, List
from .base import RepoBase


class RepoLike(RepoBase):
    REQUIRED_KEYS = ['thumb', 'submniter']

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-likes')

    def add(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)

    def delete(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)

    def get(self, key: Dict)-> Dict:
        pass

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        pass
