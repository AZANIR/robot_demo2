(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -

python -m venv venv

venv\Scripts\Activate.ps1

pip install -r requirements.txt

openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json


cd .\mgs-client\
poetry build -f wheel
Get-ChildItem ".\dist\" |
Foreach-Object {
    pip install .\dist\$_
}
cd ..\psap-simulator-client\
poetry build -f wheel
Get-ChildItem ".\dist\" |
Foreach-Object {
    pip install .\dist\$_
}
