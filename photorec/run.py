from web import create_web_app
from web import settings as web_settings


if __name__ == '__main__':
    web_app = create_web_app(web_settings.DevConfig)
    web_app.run(host="0.0.0.0", port="8080")
