# OOQuery

## OOQuery expressions

### Field

Utilitzat per comparar en un domain un camp contra un altre

```python
from ooquery.expression import Field
pol_obj = self.pool.get('giscedata.polissa')
sp = [('active', '=', True), 
 ('data_renovacio', '>=', '2025-03-10'), 
 ('data_renovacio', '<=', '2025-03-16'), 
 ('enviament', '=', 'postal'), 
 ('state', '=', 'activa'), 
 ('mode_facturacio', '!=', 'index'), 
 '|', 
    '&', 
        ('llista_preu', '!=', Field('next_pricelist_id')), 
        ('next_pricelist_id', '!=', False), 
    ('llista_preu', '!=', Field('renovacion_de_llista_preus'))]
```