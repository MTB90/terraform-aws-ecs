import web
from web import settings


if __name__ == '__main__':
    web_app = web.create_app(settings.DevConfig)
    web_app.run(host="0.0.0.0", port="8080")
