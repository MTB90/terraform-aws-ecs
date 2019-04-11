from ..base import BaseCQ
from typing import Dict


class GetAllTagsQuery(BaseCQ):
    def __init__(self, repo__tag):
        self._tag_repo = repo__tag

    def execute(self, request: Dict=None):
        tags = self._tag_repo.list(query=request)
        return tags
