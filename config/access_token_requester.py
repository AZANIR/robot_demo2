import requests
# Rename `os.environ` to `env` for clarity
from os import environ as env
from dotenv import load_dotenv
from config.default import CLIENT_ID, TOKEN_URL, SCOPE, GRANT_TYPE


def request_access_token():
    load_dotenv()
    client_secret = env.get('CLIENT_SECRET')
    json_body = {"grant_type": GRANT_TYPE, "scope": SCOPE, "client_id": CLIENT_ID, "client_secret": client_secret}
    response = requests.post(TOKEN_URL, data=json_body)
    return response.json()['access_token']
