import os
import logging
import requests
import flask_login

from flask import Blueprint, session, redirect, url_for, render_template, request
from requests.auth import HTTPBasicAuth
from datetime import datetime
from jose import jwt

blueprint = Blueprint('auth', __name__)
log = logging.getLogger(__name__)

login_manager = flask_login.LoginManager()


@blueprint.record_once
def on_load(state):
    app = state.app
    login_manager.init_app(app)
    blueprint.config = dict([(key, value) for (key, value) in app.config.items()])


class User(flask_login.UserMixin):
    """Standard flask_login UserMixin"""
    pass


@blueprint.errorhandler(401)
def unauthorized(exception):
    """Unauthorized access route"""
    return render_template("unauthorized.html"), 401


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


@blueprint.route("/login")
def login():
    """Login route"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/login-endpoint.html
    session['csrf_state'] = os.urandom(8).hex()
    cognito_login = ("https://%s/"
                     "login?response_type=code&client_id=%s"
                     "&state=%s"
                     "&redirect_uri=%s/callback" %
                     (blueprint.config['COGNITO_DOMAIN'],
                      blueprint.config['COGNITO_CLIENT_ID'],
                      session['csrf_state'],
                      blueprint.config['BASE_URL']))
    return redirect(cognito_login)


@blueprint.route("/logout")
def logout():
    """Logout route"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/logout-endpoint.html
    flask_login.logout_user()
    cognito_logout = ("https://%s/"
                      "logout?response_type=code&client_id=%s"
                      "&logout_uri=%s/" % (blueprint.config['COGNITO_DOMAIN'],
                                           blueprint.config['COGNITO_CLIENT_ID'],
                                           blueprint.config['BASE_URL']))

    return redirect(cognito_logout)


@blueprint.route("/callback")
def callback():
    """Exchange the 'code' for Cognito tokens"""
    # http://docs.aws.amazon.com/cognito/latest/developerguide/token-endpoint.html
    csrf_state = request.args.get('state')
    code = request.args.get('code')
    request_parameters = {'grant_type': 'authorization_code',
                          'client_id': blueprint.config['COGNITO_CLIENT_ID'],
                          'code': code,
                          "redirect_uri": blueprint.config['BASE_URL'] + "/callback"}
    response = requests.post("https://%s/oauth2/token" % blueprint.config['COGNITO_DOMAIN'],
                             data=request_parameters,
                             auth=HTTPBasicAuth(blueprint.config['COGNITO_CLIENT_ID'],
                                                blueprint.config['COGNITO_CLIENT_SECRET']))

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
        return redirect(url_for("main.index"))

    return render_template("error.html")


def well_known():
    # load and cache cognito JSON Web Key (JWK)
    # https://docs.aws.amazon.com/cognito/latest/developerguide/
    # amazon-cognito-user-pools-using-tokens-with-identity-providers.html

    JWKS_URL = f"https://cognito-idp.{app.config['AWS_REGION']}.amazonaws.com/" \
           f"{app.config['COGNITO_POOL_ID']}/.well-known/jwks.json"
    return requests.get(JWKS_URL).json()["keys"]


def verify(token, access_token=None):
    """Verify a cognito JWT"""
    # get the key id from the header, locate it in the cognito keys
    # and verify the key
    JWKS = well_known()
    header = jwt.get_unverified_header(token)
    key = [k for k in JWKS if k["kid"] == header['kid']][0]
    id_token = jwt.decode(token, key,
                          audience=blueprint.config['COGNITO_CLIENT_ID'],
                          access_token=access_token)
    return id_token
