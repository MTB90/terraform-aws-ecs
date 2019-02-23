from typing import Dict, List

from .base import RepoBase
from .base import ValidFilters, ValidQuery


class ValidQueryTag(ValidQuery):
    VALID_QUERY = {'type'}


class ValidFiltersTag(ValidFilters):
    VALID_FILTER = {'score'}


class RepoTag(RepoBase):
    """
    Repository for tags that encapsulate access to resources.
    """
    ValidQueryClass = ValidQueryTag
    ValidFiltersClass = ValidFiltersTag

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-tags')

    @property
    def table(self):
        return self._tags

    @property
    def required_keys(self)-> List[str]:
        return ['name']

    @property
    def required_fields(self)-> List[str]:
        return ['name']

    def add(self, item: Dict):
        self.validate_data(item, self.required_fields)
        item['type'] = 'tag'

        return self.table.update_item(
            Key={'name': item['name']},
            UpdateExpression='ADD score :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW"
        )
