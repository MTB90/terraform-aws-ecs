from infra import cq


class CQFactory:
    def __init__(self, container):
        self._container = container

    def get(self, service_class):
        return self._container.build(service_class)


cq_factory = CQFactory(container=cq)
