from abc import ABC, abstractmethod


class UseCase(ABC):
    """Base class for use cases."""

    @abstractmethod
    def execute(self, request_object):
        """Execute use case"""
