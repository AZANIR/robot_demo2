# Automation Framework to test VESTA Router

## Setup local env
### To setup env in Windows run following PowerShell script:
```commandline
setup_venv.ps1
```

## Manual steps:
### 1. Install poetry:
Linux
```bash
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
```
Windows PowerShell
```
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
```

### 2. Create venv and activate it:

Windows
```bash
python -m venv venv
venv\Scripts\Activate.ps1''
```
Linux
```bash
python -m venv venv
source venv/bin/activate
```

### 3. Install requirements:
```bash
pip install -r requirements.txt
```

### 4. Build Multimedia Gateway Simulator and Call Handler Emulator clients:

```bash
openapi-python-client generate --path open_api_clients_json/mgs_openapi.json
openapi-python-client generate --path open_api_clients_json/psap_simulator_openapi.json
```

### 5. Build wheel and install it to in your venv:

```bash
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
```