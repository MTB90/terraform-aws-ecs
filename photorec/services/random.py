from uuid import uuid4


class ServiceRandom:
    @staticmethod
    def generate_uuid4():
        return str(uuid4())
