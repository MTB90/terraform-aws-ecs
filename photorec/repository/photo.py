from typing import Dict
from .base import RepoBase


class RepoPhoto(RepoBase):
    """
    Repository for photos that encapsulate access to resources.
    """
    def __init__(self, db, config):
        secondary_index = {
            "tag": 'photo-tags', "tag__eq": 'photo-tags',
            'nickname': 'photo-nickname', 'photo__eq': 'photo-nickname'
        }
        super().__init__(db=db, config=config, secondary_index=secondary_index)

    @property
    def table(self):
        return self._db.Table(f"{self._config.DATABASE}-photos")

    def add(self, item: Dict):
        item['likes'] = 0
        return super().add(item=item)

    def update_tag(self, item: Dict):
        self.table.update_item(
            Key={'photo': item['photo']},
            UpdateExpression='SET tag = :value',
            ExpressionAttributeValues={
                ':value': item['tag']
            }
        )
