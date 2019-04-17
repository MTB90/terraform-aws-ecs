from abc import ABC, abstractmethod


class BaseCQ(ABC):
    """Base command/query class for use case."""

    @abstractmethod
    def execute(self, *args, **kwargs):
        """Execute query"""
