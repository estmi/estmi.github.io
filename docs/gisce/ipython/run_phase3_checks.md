# Run fase 3 checks

```python
    def check(self, cursor, uid, line_id):
        data = self.get_xml_from_adjunt(cursor, uid, line_id)
        res_config_obj = self.pool.get('res.config')
        productes_exclosos = res_config_obj.get(cursor, uid, 'productes_exclosos_b70', [])
        b70_xml = B70(data, 'B70', productes_exclosos=productes_exclosos)
        b70_xml.parse_xml(validate=False)
        self.pool.get('giscegas.facturacio.atr.validator').check_meter_price(cursor, uid, None, b70_xml,0, {'min_value':0,'max_value':10})
```
