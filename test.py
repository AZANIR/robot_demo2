# Rename `os.environ` to `env` for clarity
from os import environ as env
from dotenv import load_dotenv


def request_access_token():
    load_dotenv()
    item = env.get('CLIENT_SECRET')
    print(item)
    print("CLIENT_SECRET:{}".format(item if item is not None else env.get('CLIENT_SECRET')))


request_access_token()
