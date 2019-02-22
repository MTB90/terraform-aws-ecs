from abc import ABC, abstractmethod
from typing import Dict, List
from .exceptions import MissingArguments


class RepoBase(ABC):
    @abstractmethod
    def add(self, item: Dict):
        """Add new item to repository

        :param item: Item with all required fields
        """

    @abstractmethod
    def get(self, key: Dict)-> Dict:
        """Get item from repository

        :param key: Primary key for item
        """

    @abstractmethod
    def delete(self, key: Dict):
        """Remove item from repository

        :param key: Primary key for item
        """

    @abstractmethod
    def list(self, query: Dict, filters: Dict) ->List[Dict]:
        """List all items that meet query and filters conditions

        :param query: Query parameters
        :param filters: Additional parameters for filter list
        """

    @staticmethod
    def validate_data(data: Dict, required: Dict):
        """Validate if data is completed

        :param data: Data value
        :param required: Required data values
        """
        for value in required:
            if value not in data:
                raise MissingArguments(f"Missing: {value} in {data}")
