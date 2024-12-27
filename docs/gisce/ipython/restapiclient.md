# RestApiClient

- [Install](#install)
- [Import](#import)
- [Create Connection](#create-connection)
- [Usage](#usage)

## Install

```zsh
pip install pygisceclient
```

## Import

```python
from gisce import RestApiClient as Client
```

## Create Connection

```python
url = 'https://powerp-api.energiacolectiva.pro'
user = '***user***'
password = '***pwd***'
c = Client(url, user=user, password=password)
```

## Usage

Es pot utilitzar igual que un [erppeek].

```python
# Crida a API Lucera
c.LuceraApiElectricityContracts.terminate_service_on_contract(549936,'SVE','2024/05/25')

# Obtenir els ids de totes les polisses
pol_obj = c.model('giscedata.polissa')
ids = pol_obj.search([])
```

[erppeek]: /gisce/ipython/erppeek.md
