import logging
import socket

from flask import Flask, jsonify

log = logging.getLogger(__name__)
server = Flask(__name__)


@server.route('/')
def hello():
    return jsonify({
        'hello': 'world',
        'host': socket.gethostname()
    })


if __name__ == '__main__':
    server.run(host='0.0.0.0')
