from abc import ABC, abstractmethod


class UseCase(ABC):
    """Base class for use cases."""

    def execute(self, request_object):
        """Execute use case"""
        pass

    @abstractmethod
    def process_request(self, request_object):
        """Process request object"""
