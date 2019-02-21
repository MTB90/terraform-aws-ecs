from boto3.dynamodb.conditions import Key
from typing import Dict, List
from functools import reduce

from repository.exception import MissingArguments, UnsupportedQuery, UnsupportedFilter, UnsupportedFilterOperator


class ValidQuery:
    VALID_KEY = {'nickname', 'tag'}

    def __new__(cls, query: Dict):
        if len(query) > 1:
            raise UnsupportedQuery("Only one parameter is supported for query")

        key, value = list(query.items())[0]

        cls._validate_key(key)
        return cls._cast_value(key, value)

    @classmethod
    def _validate_key(cls, key):
        if key not in cls.VALID_KEY:
            raise UnsupportedQuery(f"Unsupported key:{key} supported: {cls.VALID_KEY}")

    @classmethod
    def _cast_value(cls, key, value):
        return Key(key).eq(value)


class ValidFilters:
    VALID_KEY = {'nickname', 'tag', 'likes'}
    VALID_OPERATOR = {'eq', 'lt', 'gt', 'lte', 'gte', 'between', 'begins_with'}

    def __new__(cls, filters: Dict):
        valid_filters = []
        for key, value in filters.items():
            key, operator = cls._validate_key(key)
            cls._validate_operator(operator)
            valid_filters.append(cls._cast_value(key, value, operator))

        return reduce((lambda x, y: x & y), valid_filters)

    @classmethod
    def _validate_key(cls, key):
        if '__' not in key:
            key = key + '__eq'

        key, operator = key.split('__')
        if key not in cls.VALID_KEY:
            raise UnsupportedFilter(
                f"Unsupported filter: {key}, supported: {cls.VALID_KEY}"
            )
        return key, operator

    @classmethod
    def _validate_operator(cls, operator):
        if operator not in cls.VALID_OPERATOR:
            raise UnsupportedFilterOperator(
                f"Unsupported operator: {operator} supported: {cls.VALID_OPERATOR}"
            )

    @classmethod
    def _cast_value(cls, key, value, operator):
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


class PhotoRepo:
    """
    Repository for photos that encapsulate access to resources.
    """
    REQUIRED_KEYS = ['nickname', 'thumb']
    REQUIRED_FIELDS = ['nickname', 'thumb', 'photo', 'tag']

    def __init__(self, db):
        self._photos = db.Table('photorec-dynamodb-photos')

    def add(self, item: Dict):
        """Add new photo to repository

        :param item: Item with fields (nickname, thumb, photo, tag)
        """
        self._validate_params(item, self.REQUIRED_FIELDS)
        item['likes'] = 0
        return self._photos.put_item(Item=item)

    def get(self, key: Dict):
        """Get photo information

        :param key: Primary key for photo (nickname, thumb)
        :return:
        """
        self._validate_params(key, self.REQUIRED_KEYS)
        response = self._photos.get_item(Key=key)
        if 'Item' in response:
            return response['Item']
        return None

    def delete(self, key: Dict):
        """Delete photo from repository

        :param key: Primary key for photo (nickname, thumb)
        """
        self._validate_params(key, self.REQUIRED_KEYS)
        return self._photos.delete_item(Key=key)

    def list(self, query: Dict=None, filters: Dict=None) -> List[Dict]:
        """List all elements that meet query and filter conditions.

        :param query: Query parameters base parameters
        :param filters: Filters additional parameters for query
        """
        params = {}

        if query is not None:
            params['KeyConditionExpression'] = ValidQuery(query)

        if filters is not None:
            params['FilterExpression'] = ValidFilters(filters)

        if query is None:
            response = self._photos.scan(**params)
        else:
            response = self._photos.query(**params)

        return response['Items']

    @staticmethod
    def _validate_params(params: Dict, reqiured: List):
        for value in reqiured:
            if value not in params:
                raise MissingArguments(f"Missing: {value} in {params}")
