from datetime import datetime
from tools import config
from tqdm import tqdm
from collections import OrderedDict
from slugify import slugify

imd_obj = self.pool.get('ir.model.data')
prod_obj = self.pool.get('product.product')
pol_obj = self.pool.get('giscegas.polissa')
llistapreus_obj = self.pool.get('product.pricelist')
comissio_objs = {}
price_accuracy = int(config.get('price_accuracy', 6))

categ_id = imd_obj.get_object_reference(cursor, uid, 'giscegas_facturacio_indexada', 'categ_indexada_gas')[1]
prod_ids = prod_obj.search(cursor, uid, [('categ_id', 'child_of', [categ_id])], order="name asc, default_code asc")
productes = []
for prod_id in prod_ids:
    if prod_id == 1934:
        continue  # La k ja la posem del contracte
    info = prod_obj.read(cursor, uid, prod_id, ['name'])

    new_key = slugify(info['name']).replace("-", " ").title()
    new_key = new_key.replace("€", "Eur")
    if '%' in info['name']:
        new_key += ' (%)'
    if 'Eur Mwh' in new_key:
        new_key = new_key.replace("Eur Mwh", "Eur/MWh")
    info['name'] = new_key
    productes.append(info)


pols_ids = pol_obj.search(cursor, uid, [('state', 'not in', ['esborrany'])])
pols_read = pol_obj.read(cursor, uid, pols_ids, ['name', 'llista_preu', 'state', 'coste_operativo_2', 'fee2', 'comissio'])
pricelists_products = {}
ctx = {'date':datetime.today().strftime('%Y-%m-%d')}
res = []

for pol in tqdm(pols_read):
    line =  OrderedDict()
    res.append(line)
    pol_id = pol['id']
    try:
        line['Contrato'] = pol['name']
        line['Lista de Precios'] = ''
        #line['Estado'] = pol['state']
        coeficiente_co = pol_obj.get_polissa_co(cursor, uid, pol_id, context=ctx)
        line['K'] = coeficiente_co if coeficiente_co else 0
        line['CO2'] = pol['coste_operativo_2'] if pol['coste_operativo_2'] else 0
        line['FEE2'] = pol['fee2'] if pol['fee2'] else 0
        pfee2 = 0
        pfee = 0
        if pol['comissio'] and 'maxenergia' in pol['comissio']:
            comissio_n, comissio_id = pol['comissio'].split(",")
            if comissio_n not in comissio_objs.keys():
                comissio_objs[comissio_n] = self.pool.get(comissio_n)
            comissio_obj = comissio_objs[comissio_n]
            
            preu_comi = comissio_obj.read(cursor, uid, int(comissio_id), ['porcentage_fee2','porcentage_fee'])
            pfee2 = preu_comi['porcentage_fee2'] if preu_comi['porcentage_fee2'] else 0
            pfee = preu_comi['porcentage_fee'] if preu_comi['porcentage_fee'] else 0
        line['% reparto al canal K'] = pfee
        line['% reparto al canal FEE2'] = pfee2
        if pol['llista_preu']:
            pricelist_id = pol['llista_preu'][0]
            pricelist_name = pol['llista_preu'][1]

            line['Lista de Precios'] = pricelist_name

            if str(pricelist_id) in pricelists_products.keys():
                pricelist = pricelists_products[str(pricelist_id)]
                for prod in productes:
                    line[prod['name']] = pricelist[prod['name']]
            else:
                pricelist = {}
                for prod in productes:
                    preu = round(llistapreus_obj.price_get(cursor, uid, [pricelist_id],prod['id'],1,None,context=ctx)[pricelist_id], price_accuracy)
                    pricelist[prod['name']] = preu
                    line[prod['name']] = preu
                pricelists_products[str(pricelist_id)] = pricelist
    except Exception as e:
        line['Lista de Precios'] = str(e)

if len(res) == 0:
    res.append({'Contrato':'No hay datos'})
else:
    res = sorted(res, key=lambda d: d['Contrato'])