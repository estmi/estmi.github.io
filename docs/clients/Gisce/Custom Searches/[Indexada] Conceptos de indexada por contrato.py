
from collections import OrderedDict
from datetime import datetime
imd_o = self.pool.get("ir.model.data")
prod_o = self.pool.get("product.product")
polissa_o = self.pool.get("giscedata.polissa")
llistapreus_o = self.pool.get("product.pricelist")
categ_id = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "categ_indexada")[1]
product_factor_k = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "product_factor_k")[1]
product_desvios = imd_o.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "product_desvios")[1]
prod_ids = prod_o.search(cursor, uid, [('categ_id', 'child_of', [categ_id]), ('id', 'not in', [product_factor_k, product_desvios])])

llistes_fetes = {}
llistes_names = {}
res = []
for pid in polissa_o.search(cursor, uid, [('state','=','activa'), ('mode_facturacio','=','index')]):
    pname = polissa_o.read(cursor, uid, pid, ['name'])['name']
    coeficiente_co = polissa_o.get_polissa_co(cursor, uid, pid)
    coeficiente_cd = polissa_o.get_polissa_cd(cursor, uid, pid)
    llista_id = polissa_o.read(cursor, uid, pid, ['llista_preu'])['llista_preu'][0]
    if llista_id not in llistes_fetes:
        llistes_fetes[llista_id] = {}
        llistes_names[llista_id] = llistapreus_o.read(cursor, uid, llista_id, ['name'])['name']
        for prod_inf in prod_o.read(cursor, uid, prod_ids, ['name']):
            llistes_fetes[llista_id][prod_inf['name']] = llistapreus_o.price_get(cursor, uid, [llista_id], prod_inf['id'], 1.0, context={'date': datetime.today().strftime("%Y-%m-%d")})[llista_id]

    vals = OrderedDict()
    vals['Contrato'] = pname
    vals['Lista de precios'] = llistes_names[llista_id]
    vals['CO'] = coeficiente_co
    vals['CD'] = coeficiente_cd
    for pname, price in llistes_fetes[llista_id].items():
        vals[pname] = price

    res.append(vals)
            