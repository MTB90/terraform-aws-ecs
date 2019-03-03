from web import create_web_app
import config as web_settings
from infrastructure import initialization


if __name__ == '__main__':
    config = web_settings.DevConfig
    initialization(config)

    web_app = create_web_app(config)
    web_app.run(host=config.HOST, port=config.PORT)
