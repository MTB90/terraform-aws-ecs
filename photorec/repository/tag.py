from typing import Dict
from .base import RepoBase


class RepoTag(RepoBase):
    """
    Repository for tags that encapsulate access to resources.
    """
    def __init__(self, db, config):
        secondary_index = {"type": 'tags-score', "type__eq": 'tags-score'}
        super().__init__(db=db, config=config, secondary_index=secondary_index)

    @property
    def table(self):
        return self._db.Table(f"{self._config.DATABASE}-tags")

    def add(self, item: Dict):
        response = self.table.update_item(
            Key={'name': item['name']},
            UpdateExpression='ADD score :inc, SET type = :value',
            ExpressionAttributeValues={':inc': 1, ':value': 'tag'},
            ReturnValues="UPDATED_NEW"
        )
        return response['ResponseMetadata']['HTTPStatusCode']

    def all(self):
        return self.list(query={'type': 'tag'})
