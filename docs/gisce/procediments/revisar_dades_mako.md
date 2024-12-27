# Revisar Dades Mako

Un mako obté les dades a partir del seu backend utilitzant el mètode `get_data()`.

## Report: Factura

El report de factura utilitza el backend `GiscedataFacturacioFacturaReportV2`, i utilitzarem el mètode `get_data` amb la `id` de `giscedata.facturacio.factura`.

```python
#erppeek
data = c.GiscedataFacturacioFacturaReportV2.get_data(3854230)
```
