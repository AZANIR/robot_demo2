# Rename `os.environ` to `env` for clarity
from os import environ as env
import requests
from config.default import CLIENT_ID, TOKEN_URL, SCOPE, GRANT_TYPE
from dotenv import load_dotenv


def request_access_token():
    load_dotenv()
    client_secret = env.get('CLIENT_SECRET')
    json_body = {"grant_type": GRANT_TYPE, "scope": SCOPE, "client_id": CLIENT_ID, "client_secret": client_secret}
    response = requests.post(TOKEN_URL, data=json_body)
    print(response)
    return response.json()['access_token']
