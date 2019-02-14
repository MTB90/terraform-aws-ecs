import os
from datetime import datetime
import logging
import socket
import requests
from requests.auth import HTTPBasicAuth

from flask import Flask, jsonify
from flask import render_template, redirect, session, request, url_for
import flask_login
from jose import jwt

import config
log = logging.getLogger(__name__)

app = Flask(__name__)
app.secret_key = config.FLASK_SECRET
login_manager = flask_login.LoginManager()
login_manager.init_app(app)

# load and cache cognito JSON Web Key (JWK)
# https://docs.aws.amazon.com/cognito/latest/developerguide/
# amazon-cognito-user-pools-using-tokens-with-identity-providers.html

JWKS_URL = f"https://cognito-idp.{config.AWS_REGION}.amazonaws.com/" \
           f"{config.COGNITO_POOL_ID}/.well-known/jwks.json"
JWKS = requests.get(JWKS_URL).json()["keys"]


class User(flask_login.UserMixin):
    """Standard flask_login UserMixin"""
    pass


@login_manager.user_loader
def user_loader(session_token):
    """Populate user object, check expiry"""
    if "expires" not in session:
        return None

    expires = datetime.utcfromtimestamp(session['expires'])
    expires_seconds = (expires - datetime.utcnow()).total_seconds()
    if expires_seconds < 0:
        return None

    user = User()
    user.id = session_token
    user.nickname = session['nickname']
    return user


@app.route('/')
def index():
    """Homepage route"""
    host = socket.gethostname()
    return render_template("index.html", host)


@app.route("/login")
def login():
    """Login route"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/login-endpoint.html
    session['csrf_state'] = os.urandom(8).hex()
    cognito_login = ("https://%s/"
                     "login?response_type=code&client_id=%s"
                     "&state=%s"
                     "&redirect_uri=%s/callback" %
                     (config.COGNITO_DOMAIN,
                      config.COGNITO_CLIENT_ID,
                      session['csrf_state'],
                      config.BASE_URL))
    return redirect(cognito_login)


@app.route("/logout")
def logout():
    """Logout route"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/logout-endpoint.html
    flask_login.logout_user()
    cognito_logout = ("https://%s/"
                      "logout?response_type=code&client_id=%s"
                      "&logout_uri=%s/" % (config.COGNITO_DOMAIN,
                                           config.COGNITO_CLIENT_ID,
                                           config.BASE_URL))

    return redirect(cognito_logout)


@app.route("/callback")
def callback():
    """Exchange the 'code' for Cognito tokens"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/token-endpoint.html
    csrf_state = request.args.get('state')
    code = request.args.get('code')
    request_parameters = {'grant_type': 'authorization_code',
                          'client_id': config.COGNITO_CLIENT_ID,
                          'code': code,
                          "redirect_uri": config.BASE_URL + "/callback"}
    response = requests.post("https://%s/oauth2/token" % config.COGNITO_DOMAIN,
                             data=request_parameters,
                             auth=HTTPBasicAuth(config.COGNITO_CLIENT_ID,
                                                config.COGNITO_CLIENT_SECRET))

    # the response:
    # http://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-with-identity-providers.html
    is_csrf_state_ok = csrf_state == session['csrf_state']
    if response.status_code == requests.codes.ok and is_csrf_state_ok:
        verify(response.json()["access_token"])
        id_token = verify(response.json()["id_token"],
                          response.json()["access_token"])

        user = User()
        user.id = id_token["cognito:username"]
        session['nickname'] = id_token["nickname"]
        session['expires'] = id_token["exp"]
        session['refresh_token'] = response.json()["refresh_token"]
        flask_login.login_user(user, remember=True)
        return redirect(url_for("index"))

    return render_template("error.html")


def verify(token, access_token=None):
    """Verify a cognito JWT"""
    # get the key id from the header, locate it in the cognito keys
    # and verify the key
    header = jwt.get_unverified_header(token)
    key = [k for k in JWKS if k["kid"] == header['kid']][0]
    id_token = jwt.decode(token, key,
                          audience=config.COGNITO_CLIENT_ID,
                          access_token=access_token)
    return id_token


@app.errorhandler(401)
def unauthorized(exception):
    """Unauthorized access route"""
    return render_template("unauthorized.html"), 401


@app.route('/health')
def health_check():
    return jsonify({
        'status': 'running',
        'host': socket.gethostname()
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0')
