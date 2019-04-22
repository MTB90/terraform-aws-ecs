from typing import Dict
from .base import RepoBase


class RepoTag(RepoBase):
    """
    Repository for tags that encapsulate access to resources.
    """
    def __init__(self, db):
        self._tags = db.Table(f"{self._config.DATABASE}-tags")

    @property
    def table(self):
        return self._tags

    def add(self, item: Dict):
        item['type'] = 'tag'

        return self.table.update_item(
            Key={'name': item['name']},
            UpdateExpression='ADD score :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW"
        )

    def all(self):
        tags = self.list(query={'type': 'tag'})
        return tags
