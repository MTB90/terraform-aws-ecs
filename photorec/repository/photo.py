from typing import Dict

from .base import ValidQuery, ValidFilters
from .base import RepoBase


class ValidQueryPhoto(ValidQuery):
    VALID_KEY = {'nickname', 'tag'}


class ValidFiltersPhoto(ValidFilters):
    VALID_FILTER = {'nickname', 'tag', 'likes'}


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    ValidQueryClass = ValidQueryPhoto
    ValidFiltersClass = ValidFiltersPhoto

    REQUIRED_KEYS = ['nickname', 'thumb']
    REQUIRED_FIELDS = ['nickname', 'thumb', 'photo', 'tag']

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    @property
    def table(self):
        return self._photos

    def add(self, item: Dict):
        self.validate_data(item, self.REQUIRED_FIELDS)
        item['likes'] = 0
        return self.table.put_item(Item=item)

    def get(self, key: Dict)-> Dict:
        self.validate_data(key, self.REQUIRED_KEYS)
        response = self.table.get_item(Key=key)
        if 'Item' in response:
            return response['Item']
        return None

    def delete(self, key: Dict):
        self.validate_data(key, self.REQUIRED_KEYS)
        return self.table.delete_item(Key=key)
