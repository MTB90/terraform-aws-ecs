from .base import BaseCQ


class GetHealthService(BaseCQ):
    def __init__(self, service__srvrequests):
        self._srv_requests_service = service__srvrequests

    def execute(self, service: str):
        return self._srv_requests_service.get(service, path="health", broadcast=True)
