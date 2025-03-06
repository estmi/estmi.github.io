# [INFO]
from collections import OrderedDict
from datetime import datetime
from tqdm import tqdm
from tools import config

res = []

llistapreus_obj = self.pool.get('product.pricelist')
tarifas_obj = self.pool.get('giscegas.polissa.tarifa')
periodes_obj=self.pool.get('giscegas.polissa.tarifa.periodes')
mode_fact_obj = self.pool.get('giscegas.polissa.mode.facturacio')

def obtener_precios_tarifa_gas(cursor, uid,llistapreus_obj,tarifas_obj,periodes_obj, tarifes, context = None):
    resultat = {}
    ID_LLISTA_PREUS_GAS = llistapreus_obj.search(cursor, uid, [('name', '=','TARIFAS GAS (por cliente)')])[0]

    for tarifa_atr in tarifes:
        if ID_LLISTA_PREUS_GAS in tarifa_atr['llistes_preus_comptatibles']:
            tarifa = {'name':tarifa_atr['name']}
            for periode in periodes_obj.read(cursor, uid, tarifa_atr['periodes'],['product_id', 'name', 'tipus']):
                try:
                    preu = llistapreus_obj.price_get(cursor, uid, [ID_LLISTA_PREUS_GAS],periode['product_id'][0],1,None,context=context)[ID_LLISTA_PREUS_GAS]
                except Exception as e:
                    preu = str(e)
                tarifa['{} {}'.format(periode['name'], periode['tipus'])] =  preu
            resultat[str(tarifa_atr['id'])] = tarifa        
    return resultat

today_date = datetime.today().strftime('%Y-%m-%d')

price_accuracy = int(config.get('price_accuracy', 6))

ofertables = $ver_solo_ofertables == 1

# Mode facturacio atr
mf_ids = mode_fact_obj.search(cursor, uid, [('code', '=', 'atr')])
# Pricelists atr
pricelists_atr_ids = mode_fact_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']
# Mode facturacio index
mf_ids = mode_fact_obj.search(cursor, uid, [('code', '=', 'index')])
# Pricelists index
pricelists_index_ids = mode_fact_obj.read(cursor, uid, mf_ids[0], ['compatible_price_lists'])['compatible_price_lists']

ids_pricelist = pricelists_atr_ids + pricelists_index_ids

search_params= [('id','in',ids_pricelist),('type','=','sale')]
if ofertables:
    search_params.extend([('ofertable', '=', True)])

ids_pricelist = llistapreus_obj.search(cursor, uid, search_params)

pricelists = llistapreus_obj.read(cursor, uid, ids_pricelist,['name', 'indexed_formula', 'data_inici_ofertable','data_fi_ofertable'])

tarifas_ids = tarifas_obj.search(cursor, uid, [])
tarifas_read = tarifas_obj.read(cursor, uid, tarifas_ids,['name','periodes','llistes_preus_comptatibles'])

ctx = {'date': today_date}
PREUS_TARIFA_GAS = obtener_precios_tarifa_gas(cursor, uid, llistapreus_obj,tarifas_obj,periodes_obj,tarifas_read, context=ctx)

for tarifa in tqdm(tarifas_read):
    periodes = periodes_obj.read(cursor, uid,tarifa['periodes'],['product_id', 'name', 'tipus'])
    for pricelist in pricelists:
        pricelist_id = pricelist['id']
        if pricelist_id in tarifa['llistes_preus_comptatibles']:
            fila ={
                'Nom': pricelist['name'],
                'Tarifa': tarifa['name'],
                'Data Inici': pricelist['data_inici_ofertable'],
                'Data Fi': pricelist['data_fi_ofertable'],
                'Termino Fijo':'NA',
                'Terme Variable':0,
                'Margen Termino Fijo':'NA',
                'Margen Terme Variable':0
                }
            for periode in periodes:
                product_id = periode['product_id'][0]
                tipus = 'Termino Fijo' if periode['tipus'] == 'te' else 'Termino Variable'
                if (periode['tipus'] == 'te' and pricelist_id in pricelists_atr_ids) or (periode['tipus'] == 'tp'):
                    try:
                        preu = llistapreus_obj.price_get(cursor, uid,[pricelist_id],product_id,1,None,ctx)[pricelist_id]
                    except Exception as e:
                        preu = 0
                    fila['{}'.format(tipus)] = round(preu, price_accuracy)
                    fila['Margen {}'.format(tipus)] = round(preu - PREUS_TARIFA_GAS[str(tarifa['id'])]['{} {}'.format(periode['name'], periode['tipus'])], price_accuracy)
                
            fila_ord = OrderedDict()
            fila_ord ['Nom'] = fila['Nom']
            fila_ord ['Tarifa'] = fila['Tarifa']
            fila_ord ['Data Inici'] = fila['Data Inici']
            fila_ord ['Data Fi'] = fila['Data Fi']
            fila_ord ['Termino Fijo'] = fila['Termino Fijo']
            fila_ord ['Termino Variable'] = fila['Termino Variable']
            fila_ord ['Margen Termino Fijo'] = fila['Margen Termino Fijo']
            fila_ord ['Margen Termino Variable'] = fila['Margen Termino Variable']
            res.append(fila_ord)
res = sorted(res, key=lambda d: d['Nom'])