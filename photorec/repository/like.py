from typing import Dict, List
from repository.exception import MissingArguments


class LikeRepo:
    REQUIRED_KEYS = ['thumb', 'submniter']

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-likes')

    def add(self, key: Dict):
        self._validate_params(key, self.REQUIRED_KEYS)

    def delete(self, key: Dict):
        self._validate_params(key, self.REQUIRED_KEYS)

    @staticmethod
    def _validate_params(params: Dict, reqiured: List):
        for value in reqiured:
            if value not in params:
                raise MissingArguments(f"Missing: {value} in {params}")
