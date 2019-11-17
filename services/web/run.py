from handler import create_http_app
from infra import initialization


if __name__ == '__main__':
    config = initialization()

    app = create_http_app(config)
    app.run(host=config.HOST, port=config.PORT)
