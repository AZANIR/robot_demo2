# Rename `os.environ` to `env` for clarity
from os import environ as env
from dotenv import load_dotenv

load_dotenv()


def test_secret():
    item = env.get('CLIENT_SECRET')
    print(item)
    print("CLIENT_SECRET: {}".format(env["CLIENT_SECRET"]))
