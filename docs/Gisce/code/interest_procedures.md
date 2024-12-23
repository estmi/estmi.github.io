# Procedures of Interest

## Index

## Crear polissa en esborrany per canvi de titular M1

`addons/gisce/GISCEMaster/giscedata_switching/giscedata_switching_m1.py`

```python
if vals.get("new_contract_values"):
    ctx = context.copy()
    ctx['from_atr'] = True
    pol_obj = self.pool.get('giscedata.polissa')
    pol_id = pol_obj.copy(
        cursor, uid, pas.sw_id.cups_polissa_id.id,
        default={
            'observacions': _(u"Duplicat procedent de canvi de titular ({0})").format(datetime.today().strftime("%d-%m-%Y"))
        }, context=ctx
    )
```
