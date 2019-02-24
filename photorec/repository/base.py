from abc import ABC, abstractmethod
from functools import reduce
from typing import Dict, List

from boto3.dynamodb.conditions import Key

from .exceptions import UnsupportedQuery, UnsupportedFilter, UnsupportedFilterOperator
from .exceptions import MissingArguments


class RepoBase(ABC):
    ValidQueryClass = None
    ValidFiltersClass = None

    @property
    @abstractmethod
    def table(self):
        """Get table for repository"""

    @property
    @abstractmethod
    def required_keys(self)-> List[str]:
        """Required keys"""

    @property
    @abstractmethod
    def required_fields(self)-> List[str]:
        """Required fields"""

    def add(self, item: Dict):
        """Add new item to repository

        :param item: Item with all required fields
        """
        self.validate_data(item, self.required_fields)
        return self.table.put_item(Item=item)

    def get(self, key: Dict)-> Dict:
        """Get item from repository

        :param key: Primary key for item
        """
        self.validate_data(key, self.required_keys)
        response = self.table.get_item(Key=key)
        if 'Item' in response:
            return response['Item']
        return None

    def delete(self, key: Dict):
        """Remove item from repository

        :param key: Primary key for item
        """
        self.validate_data(key, self.required_keys)
        return self.table.delete_item(Key=key)

    def list(self, query: Dict=None, filters: Dict=None) ->List[Dict]:
        """List all items that meet query and filters conditions

        :param query: Query parameters
        :param filters: Additional parameters for filter list
        """
        params = {}

        if query is not None:
            params['KeyConditionExpression'] = self.ValidQueryClass(query)

        if filters is not None:
            params['FilterExpression'] = self.ValidFiltersClass(filters)

        if query is None:
            response = self.table.scan(**params)
        else:
            response = self.table.query(**params)

        return response['Items']

    @staticmethod
    def validate_data(data: Dict, required: Dict):
        """Validate if data is completed

        :param data: Data value
        :param required: Required data values
        """
        for value in required:
            if value not in data:
                raise MissingArguments(f"Missing: {value} in {data}")


class ValidQuery:
    VALID_QUERY = None

    def __new__(cls, query: Dict):
        if len(query) > 1:
            raise UnsupportedQuery("Only one parameter is supported for query")

        key, value = list(query.items())[0]

        cls._validate_key(key)
        return cls._cast_value(key, value)

    @classmethod
    def _validate_key(cls, key):
        if key not in cls.VALID_QUERY:
            raise UnsupportedQuery(f"Unsupported key:{key} supported: {cls.VALID_QUERY}")

    @classmethod
    def _cast_value(cls, key, value):
        return Key(key).eq(value)


class ValidFilters:
    VALID_FILTER = None
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
        if key not in cls.VALID_FILTER:
            raise UnsupportedFilter(
                f"Unsupported filter: {key}, supported: {cls.VALID_FILTER}"
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
