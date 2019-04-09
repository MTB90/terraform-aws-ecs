from .base import RepoBase


class RepoLike(RepoBase):
    def __init__(self, db):
        self._likes = db.Table('photorec-dynamodb-likes')

    @property
    def table(self):
        return self._likes
