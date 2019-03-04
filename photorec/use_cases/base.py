from abc import ABC, abstractmethod
from typing import Dict


class Command(ABC):
    """Base command class for use case."""

    @abstractmethod
    def execute(self, request: Dict=None):
        """Execute command"""


class Query(ABC):
    """Base query class for use case."""

    @abstractmethod
    def execute(self, request: Dict=None):
        """Execute query"""
