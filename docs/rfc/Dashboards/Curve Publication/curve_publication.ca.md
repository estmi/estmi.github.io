# Taulell: Publicació de Corbes

## Indicadors

### Darrers F1 mes antics de 1 dia

![last_f1_older_than_1_day]

- Model: `giscedata.cups.ps`
- Domain:
    ```python
    [
        ('polissa_polissa.agree_tipus', 'in', ('01', '02', '03')),
        ('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12')),
        ('last_cchfact_datetime', '&lt;', ((datetime.datetime.today()-datetime.timedelta(1)).strftime('%Y-%m-%d 00:00:00')))
    ]
    ```
- Total Domain:
    ```python
    [
        ('polissa_polissa.agree_tipus', 'in', ('01', '02', '03')),
        ('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12'))
    ]
    ```
- Colors (basat en percentatge):
  - Vermell: \[:infinity:, 4)
  - Taronja: (5, 1)
  - Verd: \[1,0)
- Icones:
  - :frowning:: \[:infinity:, 4)
  - :expressionless:: (5, 1)
  - :smiley:: \[1,0)

### Darrers MCIL mes antics de 1 dies

![last_mcil_older_than_1_day]

- Model: `giscedata.cups.ps`
- Domain:
    ```python
    [
        ('last_mcil_datetime', '!=', False),
        ('last_mcil_datetime', '&lt;', ((datetime.datetime.today()-datetime.timedelta(1)).strftime('%Y-%m-%d 00:00:00')))
    ]
    ```
- Total Domain:
    ```python
    [
        ('last_mcil_datetime', '!=', False)
    ]
    ```
- Colors (basat en percentatge):
  - Vermell: \[:infinity:, 4)
  - Taronja: (5, 1)
  - Verd: \[1,0)
- Icones:
  - :frowning:: \[:infinity:, 4)
  - :expressionless:: (5, 1)
  - :smiley:: \[1,0)

### Darrers P1D mes antics de 1 dia

- Model: `giscedata.cups.ps`
- Domain:
    ```python
    [
        ('polissa_polissa.agree_tipus', 'in', ('01', '02', '03', '04')),
        ('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12')),
        ('cchval_format', '=', 'p1d'),
        ('last_cchval_datetime', '&lt;',
        ((datetime.datetime.today()-datetime.timedelta(1)).strftime('%Y-%m-%d 00:00:00')))
    ]
    ```
- Total Domain:
    ```python
    [
        ('polissa_polissa.agree_tipus', 'in', ('01', '02', '03', '04')),
        ('cchval_format', '=', 'p1d'),
        ('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12'))
    ]
    ```
- Colors (basat en percentatge):
  - Vermell: \[:infinity:, 4)
  - Taronja: (5, 1)
  - Verd: \[1,0)
- Icones:
  - :frowning:: \[:infinity:, 4)
  - :expressionless:: (5, 1)
  - :smiley:: \[1,0)

### Darrers P5D mes antics de 7 dies

- Model: `giscedata.cups.ps`
- Domain:
    ```python
    [   ('polissa_polissa.agree_tipus', 'in', ('03', '04', '05')),
        ('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12')),
        ('cchval_format', '=', 'p5d'),
        ('last_cchval_datetime', '&lt;',
        ((datetime.datetime.today()-datetime.timedelta(7)).strftime('%Y-%m-%d 00:00:00')))
    ]
    ```
- Total Domain:
    ```python
    [
        ('polissa_polissa.agree_tipus', 'in', ('03', '04', '05')),
        ('cchval_format', '=', 'p5d'),('polissa_polissa.tarifa.name', 'not in', ('RE', 'RE12'))
    ]
    ```
- Colors (basat en percentatge):
  - Vermell: \[:infinity:, 4)
  - Taronja: (5, 1)
  - Verd: \[1,0)
- Icones:
  - :frowning:: \[:infinity:, 4)
  - :expressionless:: (5, 1)
  - :smiley:: \[1,0)

### Last F5D older than 30 day

### Factures sense CCH disponible (90 dies)

### Factures sense A5D exportet (90 dies)

### Factures sense B5D exportet (90 dies)

### Fitxers darrers 7 dies

- Model: `giscedata.cups.ps`
- Domain:
    ```python
    [
        ('state', '!=', 'end'), ('upload_category_id.name', 'in',
        ['Fichero P5D', 'Fichero P1D', 'Fichero MCIL345', 'Fichero F5D']),
        ('create_date', '&gt;',((datetime.datetime.now()-datetime.timedelta(7)).strftime('%Y-%m-%d')))
    ]
    ```
- Total Domain:
    ```python
    [
        ('upload_category_id.name', 'in', ['Fichero P5D', 'Fichero P1D', 'Fichero MCIL345', 'Fichero F5D']),
        ('create_date', '&gt;', (datetime.datetime.today()-datetime.timedelta(7)).strftime('%%Y-%%m-%%d'))
    ]
    ```
- Colors (basat en percentatge):
  - Vermell: \[:infinity:, 4)
  - Taronja: (5, 1)
  - Verd: \[1,0)
- Icones:
  - :frowning:: \[:infinity:, 4)
  - :expressionless:: (5, 1)
  - :smiley:: \[1,0)

## Grafics

### Darrer F1

### Darrer MCIL

### Darrers P1D (90 dies)

### Darrers P5D (90 dies)

### Last F5D

[last_f1_older_than_1_day]: /rfc/dashboards/curve_publication/last_f1_older_than_1_day.png
[last_mcil_older_than_1_day]: /rfc/dashboards/curve_publication/last_mcil_older_than_1_day.png
