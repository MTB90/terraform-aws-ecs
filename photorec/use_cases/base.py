from abc import ABC, abstractmethod


class Command(ABC):
    """Base command class for use case."""

    @abstractmethod
    def execute(self, **kwargs):
        """Execute command"""


class Query(ABC):
    """Base query class for use case."""

    @abstractmethod
    def execute(self, **kwargs):
        """Execute query"""
