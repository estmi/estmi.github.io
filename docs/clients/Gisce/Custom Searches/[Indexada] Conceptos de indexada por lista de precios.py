
from collections import OrderedDict
from datetime import datetime
imd_o = self.pool.get("ir.model.data")
prod_o = self.pool.get("product.product")
llistapreus_o = self.pool.get("product.pricelist")
categ_id = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "categ_indexada")[1]
product_factor_k = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "product_factor_k")[1]
product_desvios = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "product_desvios")[1]
prod_ids = prod_o.search(cursor, uid, [('categ_id', 'child_of', [categ_id]), ('id', 'not in', [834, -1])])
prod_ids.append(2411)
llistes_fetes = {}
llistes_names = {}
res = []
llistapreus_o = self.pool.get('product.pricelist')
tarifas_o = self.pool.get('giscedata.polissa.tarifa')
periodes_o=self.pool.get('giscedata.polissa.tarifa.periodes')
mf_obj = self.pool.get('giscedata.polissa.mode.facturacio')
mf_ids = mf_obj.search(cursor, uid, [
    ('code', '=', 'index'),
    ])
pl_ids = mf_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']
from tqdm import tqdm
for llista_id in tqdm(pl_ids):
    if llista_id not in llistes_fetes:
        llistes_fetes[llista_id] = {}
        llistes_names[llista_id] = llistapreus_o.read(cursor, uid, llista_id, ['name'])['name']
        llista = llistapreus_o.browse(cursor, uid, llista_id, context={'prefetch': False})
        data_check = datetime.today().strftime("%Y-%m-%d")
        for prod_inf in prod_o.read(cursor, uid, prod_ids, ['name']):
            try:
                llistes_fetes[llista_id][prod_inf['name']] = llistapreus_o.price_get(cursor, uid, [llista_id], prod_inf['id'], 1.0, context={'date': data_check})[llista_id]
            except Exception as e:
                llistes_fetes[llista_id][prod_inf['name']] = 0

    vals = OrderedDict()
    vals['Lista de precios'] = llistes_names[llista_id]
    for pname, price in llistes_fetes[llista_id].items():
        vals[pname] = price

    res.append(vals)
            