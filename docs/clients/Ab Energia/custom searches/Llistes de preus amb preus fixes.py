# [INFO]
from collections import OrderedDict
from datetime import datetime
from tqdm import tqdm
from tools import config

res = []

llistapreus_obj = self.pool.get('product.pricelist')
tarifas_obj = self.pool.get('giscedata.polissa.tarifa')
periodes_obj=self.pool.get('giscedata.polissa.tarifa.periodes')
mode_fact_obj = self.pool.get('giscedata.polissa.mode.facturacio')

def obtener_precios_tarifa_electricidad(cursor, uid,llistapreus_obj,tarifas_obj,periodes_obj, context = None):
    resultat = {}
    #ID_LLISTA_PREUS_ELE = 4
    ID_LLISTA_PREUS_ELE = llistapreus_obj.search(cursor, uid, [('name', '=','TARIFAS ELECTRICIDAD')])[0]
    
    tarifes_atr = llistapreus_obj.read(cursor, uid, ID_LLISTA_PREUS_ELE, ['tarifes_atr_compatibles'])['tarifes_atr_compatibles']

    for tarifa_atr in tarifas_obj.read(cursor, uid, tarifes_atr, ['name','periodes']):
        tarifa = {'name':tarifa_atr['name']}
        for periode in periodes_obj.read(cursor, uid,tarifa_atr['periodes'],['product_id', 'name', 'tipus']):
            try:
                preu = llistapreus_obj.price_get(cursor, uid,[ID_LLISTA_PREUS_ELE],periode['product_id'][0],1,None,context=context)[ID_LLISTA_PREUS_ELE]
            except Exception as e:
                preu = str(e)
            tarifa['{} {}'.format(periode['name'], periode['tipus'])] =  preu
        resultat[str(tarifa_atr['id'])] = tarifa
        #resultat.append( tarifa)
    return resultat

today_date = datetime.today().strftime('%Y-%m-%d')

price_accuracy = int(config.get('price_accuracy', 6))

ofertables = $ver_solo_ofertables == 1
search_params_ofertables = [('ofertable', '=', True)]

# Mode facturacio atr
mf_ids = mode_fact_obj.search(cursor, uid, [('code', '=', 'atr')])
# Pricelists atr
pricelists_atr_ids = mode_fact_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']

# Mode facturacio index
mf_ids = mode_fact_obj.search(cursor, uid, [('code', '=', 'index')])
# Pricelists index
pricelists_index_ids = mode_fact_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']

ctx = {'date': today_date}

PREUS_TARIFA_ELECTRICIDAD = obtener_precios_tarifa_electricidad(cursor, uid, llistapreus_obj,tarifas_obj,periodes_obj, context=ctx)

compatible_pricelists = pricelists_atr_ids+pricelists_index_ids
search_params = [('id', 'in',pricelists_atr_ids+pricelists_index_ids)]
llistapreus_ids =llistapreus_obj.search(cursor, uid, search_params+search_params_ofertables if ofertables else search_params) 


llistapreus_vs = llistapreus_obj.read(cursor, uid, llistapreus_ids, ['name', 'tarifes_atr_compatibles', 'indexed_formula', 'data_inici_ofertable','data_fi_ofertable', 'ofertable', 'type'])
for llistapreus_v in tqdm(llistapreus_vs):
    if llistapreus_v['type'] == 'sale':
        formula_index= llistapreus_v['indexed_formula']
        for tarifa_id in llistapreus_v['tarifes_atr_compatibles']:
            tarifa_v = tarifas_obj.read(cursor, uid, tarifa_id, ['name','periodes'])
            fila ={
                    'Nom': llistapreus_v['name'],
                    'Tarifa': tarifa_v['name'],
                    'Data Inici': llistapreus_v['data_inici_ofertable'],
                    'Data Fi': llistapreus_v['data_fi_ofertable'],
                    'Ofertable': llistapreus_v['ofertable'],
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
                    'Margen P1 energia':0,
                    'Margen P2 energia':0,
                    'Margen P3 energia':0,
                    'Margen P4 energia':0,
                    'Margen P5 energia':0,
                    'Margen P6 energia':0,
                    'Margen P1 potencia':0,
                    'Margen P2 potencia':0,
                    'Margen P3 potencia':0,
                    'Margen P4 potencia':0,
                    'Margen P5 potencia':0,
                    'Margen P6 potencia':0,
                    }
            
            for periode_id in tarifa_v['periodes']:
                periode_v = periodes_obj.read(cursor, uid,periode_id,['product_id', 'name', 'tipus'])
                if periode_v['tipus'] == 'te':
                    tipus = 'energia'
                    product_id = periode_v['product_id'][0]
                    llistapreus_id = llistapreus_v['id']
                    if llistapreus_v['id'] in pricelists_atr_ids:
                        try:
                            preu = llistapreus_obj.price_get(cursor, uid,[llistapreus_id],product_id,1,None,ctx)[llistapreus_id]
                        except Exception as e:
                            preu = 0
                    else:
                        preu = 0
                else:
                    tipus = 'potencia'
                    product_id = periode_v['product_id'][0]
                    llistapreus_id = llistapreus_v['id']
                    try:
                        preu = llistapreus_obj.price_get(cursor, uid,[llistapreus_id],product_id,1,None,ctx)[llistapreus_id]
                    except Exception as e:
                        preu = 0
                fila['{} {}'.format(periode_v['name'], tipus)] = round(preu, price_accuracy)
                fila['Margen {} {}'.format(periode_v['name'], tipus)] = round(preu - PREUS_TARIFA_ELECTRICIDAD[str(tarifa_v['id'])]['{} {}'.format(periode_v['name'], periode_v['tipus'])], price_accuracy)
            fila_ord = OrderedDict()
            fila_ord ['Nom'] = fila['Nom']
            fila_ord ['Tarifa'] = fila['Tarifa']
            fila_ord ['Data Inici'] = fila['Data Inici']
            fila_ord ['Data Fi'] = fila['Data Fi']
            fila_ord ['Ofertable'] = fila['Ofertable']
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
            fila_ord ['Margen P1 energia'] = fila['Margen P1 energia']
            fila_ord ['Margen P2 energia'] = fila['Margen P2 energia']
            fila_ord ['Margen P3 energia'] = fila['Margen P3 energia']
            fila_ord ['Margen P4 energia'] = fila['Margen P4 energia']
            fila_ord ['Margen P5 energia'] = fila['Margen P5 energia']
            fila_ord ['Margen P6 energia'] = fila['Margen P6 energia']
            fila_ord ['Margen P1 potencia'] = fila['Margen P1 potencia']
            fila_ord ['Margen P2 potencia'] = fila['Margen P2 potencia']
            fila_ord ['Margen P3 potencia'] = fila['Margen P3 potencia']
            fila_ord ['Margen P4 potencia'] = fila['Margen P4 potencia']
            fila_ord ['Margen P5 potencia'] = fila['Margen P5 potencia']
            fila_ord ['Margen P6 potencia'] = fila['Margen P6 potencia']
            res.append(fila_ord)
