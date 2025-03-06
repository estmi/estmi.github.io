from builtins import int
from datetime import datetime
from tools import config
from tqdm import tqdm
res = []
def crear_linia( name,di_ofertable, df_ofertable, form_indx, tarifa_acces=''):
    from collections import OrderedDict    
    ord =  OrderedDict()
    ord['Tarifa Comercial'] = name
    ord['Formula Indexada'] = form_indx
    ord['Data Inici'] = di_ofertable
    ord['Data Fi'] = df_ofertable
    ord['Tarifa Acces'] = tarifa_acces
    ord['Termino Fijo']=0    
    ord['Margen Termino Fijo']=0
    return ord

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


prod_obj = self.pool.get("product.product")
llistapreus_obj = self.pool.get("product.pricelist")
tarifa_access_obj = self.pool.get("giscegas.polissa.tarifa")
periodes_obj=self.pool.get('giscegas.polissa.tarifa.periodes')
imd_obj = self.pool.get("ir.model.data")

today_date = datetime.today().strftime('%Y-%m-%d')
ctx = {'date': today_date}

ofertables = $ver_solo_ofertables == 1
price_accuracy = int(config.get('price_accuracy', 6))
categ_id = imd_obj.get_object_reference(cursor, uid, "giscegas_facturacio_indexada", "categ_indexada_gas")[1]
prod_ids = prod_obj.search(cursor, uid, [('categ_id', 'child_of', [categ_id])])
productes = prod_obj.read(cursor, uid, prod_ids, ['name'])
search_params = [('type', '=', 'sale'), ('compatible_invoicing_modes_gas', '=', 'Indexada')]

if ofertables:
    search_params.extend([('ofertable', '=', True)])
# ids pricelists de tipus venda i indexada
ids_pricelist = llistapreus_obj.search(cursor, uid, search_params)

pricelists = llistapreus_obj.read(cursor, uid, ids_pricelist,['name', 'indexed_formula', 'data_inici_ofertable','data_fi_ofertable'])

tarifas_ids = tarifa_access_obj.search(cursor, uid, [])
tarifas_read = tarifa_access_obj.read(cursor, uid, tarifas_ids,['name','periodes','llistes_preus_comptatibles'])

ctx = {'date': today_date}
PREUS_TARIFA_GAS = obtener_precios_tarifa_gas(cursor, uid, llistapreus_obj,tarifa_access_obj,periodes_obj,tarifas_read, context=ctx)

for tarifa in tqdm(tarifas_read):
    periodes = periodes_obj.read(cursor, uid,tarifa['periodes'],['product_id', 'name', 'tipus'])
    for pricelist in pricelists:
        pricelist_id = pricelist['id']
        if pricelist_id in tarifa['llistes_preus_comptatibles']:
            linia = crear_linia(pricelist['name'],pricelist['data_inici_ofertable'],pricelist['data_fi_ofertable'],pricelist['indexed_formula'],tarifa['name'])
            for periode in periodes:
                if periode['tipus'] != 'te':
                    try:
                        preu = llistapreus_obj.price_get(cursor, uid,[pricelist_id],periode['product_id'][0],1,context=ctx)[pricelist_id]
                    except Exception as e:
                        preu = 0
                    linia['{tipus}'.format(tipus='Termino Fijo')] = round(preu, price_accuracy)
                    linia['Margen {tipus}'.format(tipus='Termino Fijo')] = round(preu-PREUS_TARIFA_GAS[str(tarifa['id'])]['{} {}'.format(periode['name'], periode['tipus'])], price_accuracy)
            for product in productes:
                try:
                    preu = llistapreus_obj.price_get(cursor, uid,[pricelist_id],product['id'],1,None,context=ctx)[pricelist_id]
                except Exception as e:
                    preu = str(e)
                linia[product['name']] = preu#round(preu, price_accuracy)
            res.append(linia)
res = sorted(res, key=lambda d: d['Tarifa Comercial'])
if len(res) == 0:
    res.append({'Nom':'NO hi han llistes de preus de venda amb mode de facturacio indexada compatibles amb les tarifes'})