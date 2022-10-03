# Rename `os.environ` to `env` for clarity
from os import environ as env
from dotenv import load_dotenv


def test_secret():
    load_dotenv()
    item = env.get('CLIENT_SECRET')
    print(item)
    print("CLIENT_SECRET: {}".format(item if item != None else env.get('CLIENT_SECRET')))


test_secret()
