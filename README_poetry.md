To set up environment fo local use run from the projects root dir:


# Automation Framework to test VESTA Router

## Setup local env
### 1. Install poetry:
Linux
```bash
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
```
Windows PowerShell
```
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
```

### 2. Run poetry install script:

```bash
poetry install
```

### 3. Build Multimedia Gateway Simulator and Call Handler Emulator clients:

```bash
poetry run openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
poetry run openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json
```

### 4. Add MGS and CHE clients to your .venv:

```bash
poetry add ./mgs-client
poetry add ./psap-simulator-client
```
python -m venv venv

venv\Scripts\Activate.ps1

source venv/bin/activate

openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json


cd .\mgs-client\
poetry build -f wheel
cd ..\psap-simulator-client\
poetry build -f wheel
cd ..
pip install .\mgs-client\dist\mgs_client-22.0.65-py3-none-any.whl