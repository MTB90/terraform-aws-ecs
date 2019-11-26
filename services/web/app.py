from handler import create_http_app
from infra import initialization
from config import get_config

if __name__ == '__main__':
    config = get_config()
    initialization(config)

    app = create_http_app(config)
    app.run(host=config.HOST, port=config.PORT)
