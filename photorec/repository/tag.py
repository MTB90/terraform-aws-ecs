from typing import Dict

from .base import RepoBase
from .base import ValidFilters, ValidQuery


class ValidQueryTag(ValidQuery):
    VALID_KEY = {'type'}


class ValidFiltersTag(ValidFilters):
    VALID_FILTER = {'score'}


class RepoTag(RepoBase):
    """
    Repository for tags that encapsulate access to resources.
    """
    ValidQueryClass = ValidQueryTag
    ValidFiltersClass = ValidFiltersTag

    REQUIRED_FIELDS = ['name']

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-tags')

    @property
    def table(self):
        return self._tags

    def add(self, item: Dict):
        self.validate_data(item, self.REQUIRED_FIELDS)
        item['type'] = 'tag'

        return self.table.update_item(
            Key={'name': item['name']},
            UpdateExpression='ADD score :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW"
        )

    def get(self, key: Dict) -> Dict:
        raise NotImplemented("Method get for repo tag is unsupported")

    def delete(self, key: Dict):
        raise NotImplemented("Method delete for repo tag is unsupported")
