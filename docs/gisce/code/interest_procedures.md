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

## Agrupar linies de factura

`addons/gisce/GISCEMaster/giscedata_facturacio/giscedata_facturacio.py`

En el `giscedata.facturacio.factura.linia` en el `create`:

```python
    def create(self, cursor, uid, values, context=None):
        if not context:
            context = {}
        defaults = self.default_get(cursor, uid, ['price_unit_multi', 'multi', 'quantity'],
                                    context)
        values['invoice_id'] = \
            self.pool.get('giscedata.facturacio.factura').browse(
                                cursor, uid,
                                values['factura_id'], context={'prefetch': False}).invoice_id.id
        price_unit_multi = values.get('price_unit_multi',
                                      defaults['price_unit_multi'])
        multi = values.get('multi', defaults['multi'])
        values['price_unit'] = float_round(price_unit_multi * multi,
                                           int(config['price_accuracy']))
        query_file = ('%s/giscedata_facturacio/sql/query_factura_linia.sql'
                      % config['addons_path'])
        query = open(query_file).read()
        parameters = [values['name'],
                      values['factura_id'],
                      values['tipus'],
                      '%.6f' % values.get('price_unit_multi',
                                 defaults['price_unit_multi']),
                      values['product_id'] or 0]
        if values['tipus'] == 'energia':
            query += ' AND fl.multi = %s'
            parameters.extend([values.get('multi', defaults['multi'])])
        elif values['tipus'] == 'potencia':
            query += ' AND il.quantity = %s'
            parameters.extend([values.get('quantity', defaults['quantity'])])
        # Only group lines before 2021/09/16
        query += " AND fl.data_desde != '2021-09-16' AND fl.data_fins != '2021-12-31'"
        group_line = context.get('group_line', True)
        same_dates = False
        linies_van_seguides = True  # inicialitzem a True per mantenir comportament per defecte
        if group_line:
            cursor.execute(query, tuple(parameters))
            lids = [a[0] for a in cursor.fetchall()]
            lines_data = self.read(cursor, uid, lids, ['data_desde', 'data_fins', 'tipus'])
            if len(lines_data):
                linies_van_seguides = False  # com que si que hi ha altres linies, haurem de revisar-ho
            data_desde_list = [x['data_desde'] for x in lines_data]
            data_fins_list = [x['data_fins'] for x in lines_data]
            if values.get('data_desde', False):
                data_desde_list.append(values['data_desde'])
            if values.get('data_fins', False):
                data_fins_list.append(values['data_fins'])
            data_desde = min(data_desde_list) if data_desde_list else '2021-09-16'
            data_fins = max(data_fins_list) if data_fins_list else '2021-09-01'
            for line_data in lines_data:
                same_dates = same_dates or values['data_desde'] == line_data['data_desde'] and values['data_fins'] == line_data['data_fins']
                desde_anterior = (datetime.strptime(line_data['data_desde'], "%Y-%m-%d") - timedelta(days=1)).strftime("%Y-%m-%d")
                fins_posterior = (datetime.strptime(line_data['data_fins'], "%Y-%m-%d") + timedelta(days=1)).strftime("%Y-%m-%d")
                linies_van_seguides = linies_van_seguides or (desde_anterior == values['data_desde'] or desde_anterior == values['data_fins'] or fins_posterior == values['data_desde'] or fins_posterior == values['data_fins'])
            prev_line = False
            post_line = False
            if values.get('data_desde', False) and values.get('data_fins', False):
                prev_line = values['data_desde'] <= values['data_fins'] < '2021-09-16'
                post_line = '2021-12-31' <= values['data_desde'] <= values['data_fins']
            is_september_change = data_desde < '2021-09-16' and data_fins > '2021-09-15'
            is_december_change = data_desde < '2022-01-01' and data_fins > '2021-12-31'
            is_altres = 'altres' in values['tipus']
        if (not linies_van_seguides or not group_line or not lids or (not prev_line and is_september_change and not is_altres) or (not post_line and is_december_change and not is_altres)) and not same_dates:
            return super(GiscedataFacturacioFacturaLinia,
                         self).create(cursor, uid, values, context)
        categ_extra_id = self.pool.get('ir.model.data').get_object_reference(
            cursor, uid, 'giscedata_facturacio', 'categ_extra'
        )[1]
        for linia in self.browse(cursor, uid, lids, context={'prefetch': False}):
            # No agrupar línies de productes de categoria extra
            if (linia.product_id and linia.product_id.categ_id and
                    linia.product_id.categ_id.id == categ_extra_id or context.get('dont_group_lines', False)):
                return super(GiscedataFacturacioFacturaLinia, self).create(
                    cursor, uid, values, context)
            if (same_dates and values['data_desde'] == linia.data_desde and values['data_fins'] == linia.data_fins) or not same_dates:
                values['data_desde'] = min(linia.data_desde, values['data_desde'])
                values['data_fins'] = max(linia.data_fins, values['data_fins'])
                if self.group_line_by_multi_and_quanity(cursor, uid, linia, context=context):
                    values['quantity'] += linia.quantity
                    values['multi'] += linia.multi
                elif self.group_line_by_multi(cursor, uid, linia, context=context):
                    values['multi'] += linia.multi
                else:
                    values['quantity'] += linia.quantity
                if 'atrprice_subtotal' in values:
                    values['atrprice_subtotal'] += linia.atrprice_subtotal
                linia.write(values)
                return linia.id
```
