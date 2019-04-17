from ..base import BaseCQ


class GetAllTagsQuery(BaseCQ):
    def __init__(self, repo__tag):
        self._tag_repo = repo__tag

    def execute(self):
        tags = self._tag_repo.list()
        return tags
