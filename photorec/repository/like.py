from .base import RepoBase


class RepoLike(RepoBase):
    def __init__(self, db):
        self._likes = db.Table(f"{self._config.DATABASE}-likes")

    @property
    def table(self):
        return self._likes
