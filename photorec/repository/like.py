from .base import RepoBase


class RepoLikes(RepoBase):
    REQUIRED_KEYS = ['thumb', 'submniter']
    REQUIRED_FIELDS = ['thumb', 'submniter']

    def __init__(self, db):
        self._likes = db.Table('photorec-dynamodb-likes')

    @property
    def table(self):
        return self._likes
