# [INFO] Variables disponibles a l'scope: self (objecte custom.search), cursor, uid.
# Variable obligatoria de 'retorn': res.
# Format de la variable: Llistat de diccionaris on la clau es el camp i el valor, doncs el valor.
# Exemple:
# res = [{'name': 'GISCE', 'phone': '972 21 73 84'}]
from collections import OrderedDict
from datetime import datetime
from tqdm import tqdm 
res = []
llistapreus_o = self.pool.get('product.pricelist')
tarifas_o = self.pool.get('giscedata.polissa.tarifa')
periodes_o=self.pool.get('giscedata.polissa.tarifa.periodes')
mf_obj = self.pool.get('giscedata.polissa.mode.facturacio')
mf_ids = mf_obj.search(cursor, uid, [
    ('code', '=', 'atr'),
    ])
pl_ids_atr = mf_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']
mf_ids = mf_obj.search(cursor, uid, [
    ('code', '=', 'index'),
    ])
pl_ids_index = mf_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']

llistapreus_vs = llistapreus_o.read(cursor, uid, pl_ids_atr+pl_ids_index, ['name', 'tarifes_atr_compatibles', 'indexed_formula', 'type'])
for llistapreus_v in tqdm(llistapreus_vs):
    if llistapreus_v['type'] == 'sale':
        formula_index= llistapreus_v['indexed_formula']
        for tarifa_id in llistapreus_v['tarifes_atr_compatibles']:
            tarifa_v = tarifas_o.read(cursor, uid, tarifa_id, ['name','periodes'])
            fila ={
                    'Nom': llistapreus_v['name'],
                    'Tarifa': tarifa_v['name'],
                    'P1 energia':0,
                    'P2 energia':0,
                    'P3 energia':0,
                    'P4 energia':0,
                    'P5 energia':0,
                    'P6 energia':0,
                    'P1 potencia':0,
                    'P2 potencia':0,
                    'P3 potencia':0,
                    'P4 potencia':0,
                    'P5 potencia':0,
                    'P6 potencia':0,
                    }

            for periode_id in tarifa_v['periodes']:
                periode_v = periodes_o.read(cursor, uid,periode_id,['product_id', 'name', 'tipus'])
                if periode_v['tipus'] == 'te':
                    tipus = 'energia'
                    product_id = periode_v['product_id'][0]
                    ctx = {'date': datetime.today().strftime('%Y-%m-%d')}
                    llistapreus_id = llistapreus_v['id']
                    if llistapreus_v['id'] in pl_ids_atr:
                        try:
                            preu = llistapreus_o.price_get(cursor, uid,[llistapreus_id],product_id,1,None,ctx)[llistapreus_id]
                        except Exception as e:
                            preu = 0
                    else:
                        preu = 0
                else:
                    tipus = 'potencia'
                    product_id = periode_v['product_id'][0]
                    ctx = {'date': datetime.today().strftime('%Y-%m-%d')}
                    llistapreus_id = llistapreus_v['id']
                    try:
                        preu = llistapreus_o.price_get(cursor, uid,[llistapreus_id],product_id,1,None,ctx)[llistapreus_id]
                    except Exception as e:
                        preu = 0
                fila['{} {}'.format(periode_v['name'], tipus)] = preu
                fila_ord = OrderedDict()
                fila_ord ['Nom'] = fila['Nom']
                fila_ord ['Tarifa'] = fila['Tarifa']
                fila_ord ['P1 energia'] = fila['P1 energia']
                fila_ord ['P2 energia'] = fila['P2 energia']
                fila_ord ['P3 energia'] = fila['P3 energia']
                fila_ord ['P4 energia'] = fila['P4 energia']
                fila_ord ['P5 energia'] = fila['P5 energia']
                fila_ord ['P6 energia'] = fila['P6 energia']
                fila_ord ['P1 potencia'] = fila['P1 potencia']
                fila_ord ['P2 potencia'] = fila['P2 potencia']
                fila_ord ['P3 potencia'] = fila['P3 potencia']
                fila_ord ['P4 potencia'] = fila['P4 potencia']
                fila_ord ['P5 potencia'] = fila['P5 potencia']
                fila_ord ['P6 potencia'] = fila['P6 potencia']
            res.append(fila_ord)
