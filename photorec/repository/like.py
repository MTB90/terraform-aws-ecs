from .base import RepoBase


class RepoLike(RepoBase):
    def __init__(self, db, config):
        super().__init__(db=db, config=config)
        self._likes = db.Table(f"{self._config.DATABASE}-likes")

    @property
    def table(self):
        return self._likes
