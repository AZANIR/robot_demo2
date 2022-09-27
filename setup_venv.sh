curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -

export PATH="$HOME/.poetry/bin:$PATH"

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json


cd mgs-client/
poetry build -f wheel
for filename in ./dist/*.whl; do
    pip install "$filename"
done


cd ../psap-simulator-client/
poetry build -f wheel
for filename in ./dist/*.whl; do
    pip install "$filename"
done
