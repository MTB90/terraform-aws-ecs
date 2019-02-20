from boto3.dynamodb.conditions import Key
from typing import Dict, List
from functools import reduce


class MissingArguments(Exception):
    pass


class UnsupportedQuery(Exception):
    pass


class UnsupportedFilter(Exception):
    pass


class UnsupportedFilterOperator(Exception):
    pass


class PhotoRepo:
    """
    Repository for photos that encapsulate access to resources.
    """
    QUERY = ['nickname', 'tag']
    FILTERS = {'nickname', 'tag', 'likes'}
    PRIMARY_KEY = {'nickname', 'thumb'}
    REQUIRED_FIELDS = ['nickname', 'thumb', 'photo', 'tag']

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    def add(self, item: Dict):
        """Add new photo to repository

        :param item: Item with fields (nickname, thumb, photo, tag)
        """
        for field in self.REQUIRED_FIELDS:
            if field not in item:
                raise MissingArguments(f"Missing field: {field} in {item}")

        self._photos.put_item(Item=item)

    def get(self, key: Dict):
        """Get photo information

        :param key: Primary key for photo (nickname, thumb)
        """
        self._photos.get_item(Key=key)

    def delete(self, key: Dict):
        """Delete photo from repository

        :param key: Primary key for photo (nickname, thumb)
        """
        self._photos.delete_item(Key=key)

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        """List all elements that meet query and filter conditions.

        :param query: Query parameters base parameters
        :param filters: Filters additional parameters for query
        :return:
        """
        valid_query = self._validate_query(query)
        valid_filters = self._validate_filters(filters)
        params = {}

        if valid_query is not None:
            params['KeyConditionExpression'] = valid_query

        if valid_filters is not None:
            params['FilterExpression'] = reduce(
                (lambda x, y: x & y), valid_filters
            )

        if valid_query is None:
            response = self._photos.scan(**params)
        else:
            response = self._photos.query(**params)

        return response['Items']

    def _validate_query(self, query: Dict):
        if query is None:
            return None

        if len(query) != 1:
            raise UnsupportedQuery("Only one parameter is supported for query")

        for key in self.QUERY:
            if key in query:
                return Key(key).eq(query[key])
        raise UnsupportedQuery(f"Unknown key:{key} for query supported: {self.QUERY}")

    def _validate_filters(self, filters: Dict):
        if filters is None:
            return None

        list_filters = []
        for key, value in filters.items():
            if '__' not in key:
                key = key + '__eq'

            key, operator = key.split('__')
            if key not in self.FILTERS:
                raise UnsupportedFilter(
                    f"Unknown filter:{key} for filter supported: {self.FILTERS}"
                )

            list_filters.append(self._validate_value(key, value, operator))

        return list_filters

    @staticmethod
    def _validate_value(key, value, operator):
        valid_operators = {'eq', 'lt', 'gt', 'lte', 'gte', 'between', 'begins_with'}
        if operator not in valid_operators:
            raise UnsupportedFilterOperator(f"Operator {operator} is not supported")

        value_type = type(value)

        if value_type == str and operator in {'eq', 'begins_with'}:
            return getattr(Key(key), operator)(value)

        if value_type == int and operator in {'eq', 'lt', 'gt', 'lte', 'gte'}:
            return getattr(Key(key), operator)(value)

        if value_type == tuple and operator == 'between':
            return Key(key).between(*value)

        raise UnsupportedFilterOperator(
            f"Value: {value} with operator {operator} is not supported"
        )
