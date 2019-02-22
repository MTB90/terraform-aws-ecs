from typing import Dict, List

from .base import RepoBase


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
        response = self._tags.scan(ScanIndexForward=False)
        items = response['Items']
        return items

    def get(self, key: Dict) -> Dict:
        pass

    def delete(self, key: Dict):
        pass
