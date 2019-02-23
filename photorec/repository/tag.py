from typing import Dict, List

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

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-tags')

    def add(self, item: Dict):
        item['type'] = 'tag'
        return self._tags.update_item(
            Key={'name': item['name']},
            UpdateExpression='ADD score :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW"
        )

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        params = {}

        if query is not None:
            params['KeyConditionExpression'] = ValidQueryTag(query)

        if filters is not None:
            params['FilterExpression'] = ValidFiltersTag(filters)

        if query is None:
            response = self._tags.scan(**params)
        else:
            response = self._tags.query(**params)

        return response['Items']

    def get(self, key: Dict) -> Dict:
        pass

    def delete(self, key: Dict):
        pass
