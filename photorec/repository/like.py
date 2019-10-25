from .base import RepoBase


class RepoLike(RepoBase):
    def __init__(self, db, config):
        super().__init__(db=db, config=config)

    @property
    def table(self):
        return self._db.Table(f"{self._config.DATABASE}-likes")
