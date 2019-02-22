from abc import ABC, abstractmethod
from typing import Dict, List


class RepoBase(ABC):
    @abstractmethod
    def add(self, item: Dict):
        """Add new item to repository"""

    @abstractmethod
    def get(self, key: Dict)-> Dict:
        """Get item from repository"""

    @abstractmethod
    def delete(self, key: Dict):
        """Remove item from repository"""

    def list(self, query: Dict, filter: Dict) ->List[Dict]:
        """List all items that meet query and filter conditions"""
