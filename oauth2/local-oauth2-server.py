from flask import Flask, jsonify, redirect, url_for, request
from authlib.integrations.flask_oauth2 import AuthorizationServer, ResourceProtector
from authlib.oauth2.rfc6749 import grants
from werkzeug.security import gen_salt
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)

# OAuth 2.0 Authorization Server setup
authorization = AuthorizationServer(app)

# Simulate an OAuth2 Password Grant
class OAuth2PasswordGrant(grants.ResourceOwnerPasswordCredentialsGrant):
    def authenticate_user(self, username, password):
        # Mock user authentication logic (using hardcoded username and password)
        if username == 'test' and password == 'password':
            return {'id': 1, 'username': 'test'}
        return None

# Register the Password Grant
authorization.register_grant(OAuth2PasswordGrant)

# Resource protection
require_oauth = ResourceProtector()

@app.route('/')
def home():
    return 'Welcome to the OAuth2.0 mock provider test! <a href="/login">Login to get OAuth Token</a>'

@app.route('/login')
def login():
    return redirect(url_for('authorize'))

@app.route('/authorize')
def authorize():
    # Simulate an OAuth2 authorization request and user consent
    return authorization.create_authorization_response(grant_user={'id': 1, 'username': 'test'})

@app.route('/token', methods=['POST'])
def issue_token():
    # OAuth2 Token endpoint, issues a token using the password grant flow
    return authorization.create_token_response()

@app.route('/protected')
@require_oauth('profile')
def protected():
    # This is a protected resource; only accessible with a valid token
    return jsonify(message="This is a protected resource!")

if __name__ == '__main__':
    app.run(debug=True)
