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
        filters = all(self._validate_filters(filters))

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

            yield self._validate_value(key, value, operator)

    @staticmethod
    def _validate_value(key, value, operator):
        operators = {'eq', 'lt', 'gt', 'lte', 'gte', 'between', 'begins_with'}
        if operator not in operators:
            raise ValueError(f"Operator {operator} is not supported")

        cast_type = {'begins_with': str, 'between': tuple}
        value_type = cast_type.get(operator, int)

        if isinstance(value, value_type):
            if value_type == tuple:
                return Key(key).between(*value)
            return getattr(Key(key), operator)(value)

        raise ValueError(f"Operator {operator} required {value_type} value")
