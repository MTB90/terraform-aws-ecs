from typing import Dict, List

from .base import ValidQuery, ValidFilters
from .base import RepoBase


class ValidQueryPhoto(ValidQuery):
    VALID_QUERY = {'nickname', 'tag'}


class ValidFiltersPhoto(ValidFilters):
    VALID_FILTER = {'nickname', 'tag', 'likes'}


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    ValidQueryClass = ValidQueryPhoto
    ValidFiltersClass = ValidFiltersPhoto

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    @property
    def table(self):
        return self._photos

    @property
    def required_keys(self)-> List[str]:
        return ['nickname', 'thumb']

    @property
    def required_fields(self)-> List[str]:
        return ['nickname', 'thumb', 'photo', 'tag']

    def add(self, item: Dict):
        self.validate_data(item, self.required_fields)
        item['likes'] = 0
        return self.table.put_item(Item=item)
