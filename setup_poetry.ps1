(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -

poetry install

poetry run openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
poetry run openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json

poetry add ./mgs-client
poetry add ./psap-simulator-client