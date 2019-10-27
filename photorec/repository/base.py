from abc import ABC, abstractmethod
from functools import reduce
from typing import Dict, List

from boto3.dynamodb.conditions import Key


class RepoBase(ABC):
    def __init__(self, db, config, secondary_index):
        self._db = db
        self._config = config
        self._secondary_index = secondary_index

    @property
    @abstractmethod
    def table(self):
        """Get table for repository"""

    def _get_index(self, query):
        if query is not None:
            for key in self._secondary_index.keys():
                if key in query:
                    return self._secondary_index[key]
        return None

    def add(self, item: Dict):
        """Add new item to repository

        :param item: Item with all required fields
        """
        response = self.table.put_item(Item=item)
        return response['ResponseMetadata']['HTTPStatusCode']

    def get(self, key: Dict, consistent_read=True) -> Dict:
        """Get item from repository

        :param consistent_read: ConsistentRead for get item in dynamodb
        :param key: Primary key for item
        """
        response = self.table.get_item(Key=key, ConsistentRead=consistent_read)
        if 'Item' in response:
            return response['Item']
        return None

    def delete(self, key: Dict):
        """Remove item from repository

        :param key: Primary key for item
        """
        response = self.table.delete_item(Key=key)
        return response['ResponseMetadata']['HTTPStatusCode']

    def list(self, query: Dict = None, filters: Dict = None) -> List[Dict]:
        """List all items that meet query and filters conditions using index

        :param query: Query parameters
        :param filters: Additional parameters for filter list
        """
        params = {}

        index = self._get_index(query)
        if index is not None:
            params['IndexName'] = index

        if query is not None:
            params['KeyConditionExpression'] = Expression(query)

        if filters is not None:
            params['FilterExpression'] = Expression(filters)

        if query is None:
            response = self.table.scan(**params)
        else:
            response = self.table.query(**params)
        return response['Items']


class UnsupportedExpression(Exception):
    pass


class Expression:
    VALID_OPERATOR = {'eq', 'lt', 'gt', 'lte', 'gte', 'between', 'begins_with'}

    def __new__(cls, expressions: Dict):
        valid_expressions = []
        for key, value in expressions.items():
            key, operator = cls._cast_key(key)
            valid_expressions.append(cls._cast_value(key, value, operator))

        return reduce((lambda x, y: x & y), valid_expressions)

    @classmethod
    def _cast_key(cls, key):
        if '__' not in key:
            key = key + '__eq'

        key, operator = key.split('__')
        return key, operator

    @classmethod
    def _cast_value(cls, key, value, operator):
        try:
            value_type = type(value)
            if value_type == str and operator in {'eq', 'begins_with'}:
                return getattr(Key(key), operator)(value)

            if value_type == int and operator in {'eq', 'lt', 'gt', 'lte', 'gte'}:
                return getattr(Key(key), operator)(value)

            if value_type == tuple and operator == 'between':
                return Key(key).between(*value)
        except:
            pass

        raise UnsupportedExpression(
            f"Value: {value} with operator {operator} is not supported"
        )
