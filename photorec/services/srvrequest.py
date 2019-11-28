from random import randint
from typing import List
import requests
import dns.resolver

from ..common.errors import BaseError


class NoSrvRecordsError(BaseError):
    def __init__(self, code=404, message=''):
        super().__init__(code=code, message=message)


class SrvResponse:
    url: str
    response: str


class SrvRequest:
    def __init__(self):
        pass

    def get(self, qname, path, params=None, broadcast=False, random=True) -> List:
        responses = []
        srv_records = self._resolver(qname)

        if len(srv_records) <= 0:
            raise NoSrvRecordsError(message=f"No SRV records for: {qname}")

        if not broadcast:
            if random:
                srv_records = [srv_records[randint(0, len(srv_records) - 1)]]
            else:
                srv_records = [srv_records[0]]

        for srv_record in srv_records:
            response = self._http_request(srv_record['host'], path, srv_record['port'], params)
            responses.append(response)

        return responses

    @staticmethod
    def _resolver(qname):
        srv_records = []

        for srv in dns.resolver.query(qname, 'SRV'):
            srv_info = {
                'weight': int(srv.weight),
                'host': str(srv.target).rstrip('.'),
                'priority': int(srv.priority),
                'port': srv.port
            }
            srv_records.append(srv_info)

        return srv_records

    @staticmethod
    def _http_request(host, path, port, params):
        url = f"http://{host}:{port}/{path}"
        response = requests.get(url, params)
        return SrvResponse(url, response)
