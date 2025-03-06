from tqdm import tqdm
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

pol_ids = polissa_o.search(cursor, uid, [('mode_facturacio','=','index')], context={'active_test':False})
pol_fields = ['name','fee_p1','fee_p2','fee_p3','fee_p4','fee_p5','fee_p6','coste_operativo_2','fee2', 'comissio', 'tarifa', 'potencia','llista_preu']
for pol in tqdm(polissa_o.read(cursor, uid, pol_ids, pol_fields), desc='CS_[Indexada] Conceptos de indexada por todos los contratos'):
    pname = pol['name']
    try:
        coeficiente_co = polissa_o.get_polissa_co(cursor, uid, pol['id'])
    except:
        coeficiente_co = 0
    try:    
        coeficiente_cd = polissa_o.get_polissa_cd(cursor, uid, pol['id'])
    except:
        coeficiente_cd = 0
    co2 = pol['coste_operativo_2']
    fee2 = pol['fee2']
    pfee2 = 0
    if pol['comissio'] and 'maxenergia' in pol['comissio'] and pol['tarifa']:
        comissio_n, comissio_id = pol['comissio'].split(",")
        comissio_o = self.pool.get(comissio_n)
        if pol['tarifa'][1] == "2.0TD":
            if pol['potencia'] <= 10:
                proname = "porcentage_fee2_20td_under_10"
            else:
                proname = "porcentage_fee2_20td_over_10"
        elif pol['tarifa'][1] == "3.0TD":
             proname = "porcentage_fee2_30td"
        else:
             proname = "porcentage_fee2_6xtd"
        pfee2 = comissio_o.read(cursor, uid, int(comissio_id), [proname])[proname]
    
    if pol['llista_preu']:
        llista_id = pol['llista_preu'][0]
        if llista_id not in llistes_fetes:
            llistes_fetes[llista_id] = {}
            llistes_names[llista_id] = llistapreus_o.read(cursor, uid, llista_id, ['name'])['name']
            for prod_inf in prod_o.read(cursor, uid, prod_ids, ['name']):
                try:
                    llistes_fetes[llista_id][prod_inf['name']] = llistapreus_o.price_get(cursor, uid, [llista_id], prod_inf['id'], 1.0, context={'date': datetime.today().strftime("%Y-%m-%d")})[llista_id]
                except:
                    llistes_fetes[llista_id][prod_inf['name']] = 0

    vals = OrderedDict()
    vals['Contrato'] = pname
    vals['Lista de precios'] = llistes_names[llista_id]
    vals['CO'] = coeficiente_co
    vals['CO2'] = co2
    vals['FEE2'] = fee2
    vals['FEE P1 (Indexada Max)'] = pol['fee_p1']
    vals['FEE P2 (Indexada Max)'] = pol['fee_p2']
    vals['FEE P3 (Indexada Max)'] = pol['fee_p3']
    vals['FEE P4 (Indexada Max)'] = pol['fee_p4']
    vals['FEE P5 (Indexada Max)'] = pol['fee_p5']
    vals['FEE P6 (Indexada Max)'] = pol['fee_p6']
    vals['% reparto al canal FEE2'] = pfee2
    vals['CD'] = coeficiente_cd
    for pname, price in llistes_fetes[llista_id].items():
        vals[pname] = price

    res.append(vals)
            