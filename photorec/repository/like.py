from typing import List

from .base import RepoBase
from .base import ValidQuery, ValidFilters


class ValidQueryLike(ValidQuery):
    VALID_QUERY = {'thumb'}


class ValidFiltersLike(ValidFilters):
    VALID_FILTER = {'submitter'}


class RepoLike(RepoBase):

    ValidQueryClass = ValidQueryLike
    ValidFiltersClass = ValidFiltersLike

    def __init__(self, db):
        self._likes = db.Table('photorec-dynamodb-likes')

    @property
    def table(self):
        return self._likes

    @property
    def required_keys(self) -> List[str]:
        return ['thumb', 'submitter']

    @property
    def required_fields(self) -> List[str]:
        return ['thumb', 'submitter']
