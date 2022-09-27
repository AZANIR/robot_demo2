(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -

poetry install

poetry run openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
poetry run openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json

poetry add ./mgs-client
poetry add ./psap-simulator-client