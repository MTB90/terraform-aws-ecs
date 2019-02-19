from boto3.dynamodb.conditions import Key
from typing import Dict, List


class PhotoRepo:
    """
    Repository for photos that encapsulate access to resources.
    """
    KEYS = ['nickname', 'tag']
    FILTERS = {'nickname', 'tag', 'likes'}
    SORT = {'likes'}

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        """List all elements that meet query and filter conditions.

        :param query: Query parameters base parameters
        :param filters: Filters additional parameters for query
        :return:
        """
        query = self._validate_query(query)
        filters = self._validate_filters(filters)
        return []

    def _validate_query(self, query: Dict):
        if query is None:
            return None

        if len(query) != 1:
            raise ValueError("Only one parameter is supported for query")

        for key in self.KEYS:
            if key in query:
                return Key(key).eq(query[key])
        raise KeyError(f"Unknown key:{key} for query supported: {self.KEYS}")

    def _validate_filters(self, filters: Dict):
        if filters is None:
            return None

        for key, value in filters.items():
            if '__' not in key:
                key = key + '__eq'

            key, operator = key.split('__')
            if key not in self.FILTERS:
                raise KeyError(f"Unknown key:{key} for filter supported: {self.FILTERS}")

            if operator == 'begins_with':
                if not isinstance(value, str):
                    raise ValueError(f"Operator {operator} required string value")
                continue
            elif operator == 'between':
                if not isinstance(value, tuple):
                    raise ValueError(f"Operator {operator} required tuple value")
                continue
            elif operator in {'eq', 'lt', 'gt', 'lte', 'gte'}:
                if not isinstance(value, int):
                    raise ValueError(f"Operator {operator} required string value")
                continue

            raise ValueError(f"Operator {operator} is not supported")
