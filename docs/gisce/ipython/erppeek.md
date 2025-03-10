# ErpPeek

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
from erppeek import Client
```

## Create Connection

```python
def connection():
    from erppeek import Client
    c = Client('http://localhost:18069', 'montoliu_comer','gisce')
    return c
c = connection()
```

## Usage

Es pot utilitzar igual que un [RestApiClient]. Tots els metodes s'executen igual que l'erp, pero sense escriure cursor i uid, erppeek, ja ho infereix.

```python
# Crida a API Lucera
c.LuceraApiElectricityContracts.terminate_service_on_contract(549936,'SVE','2024/05/25')

# Obtenir els ids de totes les polisses
pol_obj = c.model('giscedata.polissa')
ids = pol_obj.search([])
```

[RestApiClient]: /gisce/ipython/restapiclient.md
