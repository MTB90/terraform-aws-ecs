from ..base import Query


class GetAllTags(Query):
    def __init__(self, repo__tag):
        self._tag_repo = repo__tag

    def execute(self):
        return {}
