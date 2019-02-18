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


class User(flask_login.UserMixin):
    """Standard flask_login UserMixin"""
    pass


@login_manager.user_loader
def user_loader(session_token):
    """Populate user object, check expiry"""
    if "expires" not in session:
        return None

    expires = datetime.utcfromtimestamp(session['expires'])
    if (expires - datetime.utcnow()).total_seconds() < 0:
        return None

    user = User()
    user.id = session_token
    user.nickname = session['nickname']
    return user


@blueprint.record_once
def setup_blueprint(state):
    """
    Setup blueprint when is register to the application

    :param state: State object with current app
    """
    app = state.app
    login_manager.init_app(app)
    blueprint.config = {key: value for (key, value) in app.config.items()}


@blueprint.route("/login")
def login():
    """ Login route """
    # http://docs.aws.amazon.com/cognito/latest/developerguide/login-endpoint.html
    session['csrf_state'] = os.urandom(8).hex()
    log.error(blueprint.config)
    url = f"https://{blueprint.config['COGNITO_DOMAIN']}/login?response_type=code&" \
          f"client_id={blueprint.config['COGNITO_CLIENT_ID']}&" \
          f"state={session['csrf_state']}&" \
          f"redirect_uri={blueprint.config['BASE_URL']}/callback"
    log.error(url)
    return redirect(url)


@blueprint.route("/logout")
def logout():
    """ Logout route """
    # http://docs.aws.amazon.com/cognito/latest/developerguide/logout-endpoint.html
    flask_login.logout_user()
    url = f"https://{blueprint.config['COGNITO_DOMAIN']}/logout?response_type=code&" \
          f"client_id={blueprint.config['COGNITO_CLIENT_ID']}&" \
          f"logout_uri={blueprint.config['BASE_URL']}/"

    return redirect(url)


@blueprint.route("/callback")
def callback():
    """ Exchange the 'code' for Cognito tokens """
    # http://docs.aws.amazon.com/cognito/latest/developerguide/token-endpoint.html
    csrf_state = request.args.get('state')

    url = f"https://{blueprint.config['COGNITO_DOMAIN']}/oauth2/token"
    data = {
        'grant_type': 'authorization_code', 'code': request.args.get('code'),
        'client_id': blueprint.config['COGNITO_CLIENT_ID'],
        "redirect_uri": f"{blueprint.config['BASE_URL']}/callback"
    }

    auth = HTTPBasicAuth(
        blueprint.config['COGNITO_CLIENT_ID'],
        blueprint.config['COGNITO_CLIENT_SECRET']
    )

    response = requests.post(url=url, data=data, auth=auth)

    # the response:
    # http://docs.aws.amazon.com/cognito/latest/developerguide/
    # amazon-cognito-user-pools-using-tokens-with-identity-providers.html

    is_csrf_state_ok = csrf_state == session['csrf_state']
    if response.status_code == requests.codes.ok and is_csrf_state_ok:
        verify(response.json()["access_token"])
        id_token = verify(
            response.json()["id_token"],
            response.json()["access_token"]
        )

        user = User()
        user.id = id_token["cognito:username"]
        session['nickname'] = id_token["nickname"]
        session['expires'] = id_token["exp"]
        session['refresh_token'] = response.json()["refresh_token"]

        flask_login.login_user(user, remember=False)
        return redirect(url_for("main.index"))

    return render_template("error.html")


@blueprint.errorhandler(401)
def unauthorized(exception):
    """ Unauthorized access route """
    return render_template("unauthorized.html"), 401


def well_known_jwks():
    """ Load and cache cognito JSON Web Key (JWK)
    https://docs.aws.amazon.com/cognito/latest/developerguide/
    amazon-cognito-user-pools-using-tokens-with-identity-providers.html
    """
    url = f"https://cognito-idp.{blueprint.config['AWS_REGION']}.amazonaws.com/" \
          f"{blueprint.config['COGNITO_POOL_ID']}/.well-known/jwks.json"

    return requests.get(url).json()["keys"]


def verify(token, access_token=None):
    """ Verify a cognito JWT """
    # get the key id from the header, locate it in the cognito keys
    # and verify the key
    jwks = well_known_jwks()

    header = jwt.get_unverified_header(token)
    key = [k for k in jwks if k["kid"] == header['kid']][0]
    id_token = jwt.decode(token, key,
                          audience=blueprint.config['COGNITO_CLIENT_ID'],
                          access_token=access_token)
    return id_token
