from typing import Dict, List

from .base import ValidQuery, ValidFilters
from .base import RepoBase


class ValidQueryPhoto(ValidQuery):
    VALID_KEY = {'nickname', 'tag'}


class ValidFilterPhoto(ValidFilters):
    VALID_FILTER = {'nickname', 'tag', 'likes'}


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    REQUIRED_KEYS = ['nickname', 'thumb']
    REQUIRED_FIELDS = ['nickname', 'thumb', 'photo', 'tag']

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    def add(self, item: Dict):
        self.validate_data(item, self.REQUIRED_FIELDS)
        item['likes'] = 0
        return self._photos.put_item(Item=item)

    def get(self, key: Dict)-> Dict:
        self.validate_data(key, self.REQUIRED_KEYS)
        response = self._photos.get_item(Key=key)
        if 'Item' in response:
            return response['Item']
        return None

    def delete(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)
        return self._photos.delete_item(Key=key)

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        params = {}

        if query is not None:
            params['KeyConditionExpression'] = ValidQueryPhoto(query)

        if filters is not None:
            params['FilterExpression'] = ValidFilterPhoto(filters)

        if query is None:
            response = self._photos.scan(**params)
        else:
            response = self._photos.query(**params)

        return response['Items']
