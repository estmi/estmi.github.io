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
    ord['P1 potencia']=0    
    ord['P2 potencia']=0    
    ord['P3 potencia']=0    
    ord['P4 potencia']=0    
    ord['P5 potencia']=0    
    ord['P6 potencia']=0
    ord['Margen P1 potencia']=0
    ord['Margen P2 potencia']=0
    ord['Margen P3 potencia']=0
    ord['Margen P4 potencia']=0
    ord['Margen P5 potencia']=0
    ord['Margen P6 potencia']=0
    return ord

def obtener_precios_tarifa_electricidad(cursor, uid,llistapreus_obj,tarifas_obj,periodes_obj, context = None):
    resultat = {}
    ID_LLISTA_PREUS_ELE = llistapreus_obj.search(cursor, uid, [('name', '=','TARIFAS ELECTRICIDAD')])[0]
    
    tarifes_atr = llistapreus_obj.read(cursor, uid, ID_LLISTA_PREUS_ELE, ['tarifes_atr_compatibles'])['tarifes_atr_compatibles']

    for tarifa_atr in tarifas_obj.read(cursor, uid, tarifes_atr, ['name','periodes']):
        tarifa = {'name':tarifa_atr['name']}
        for periode in periodes_obj.read(cursor, uid,tarifa_atr['periodes'],['product_id', 'name', 'tipus']):
            try:
                preu = llistapreus_obj.price_get(cursor, uid,[ID_LLISTA_PREUS_ELE],periode['product_id'][0],1,None,context=context)[ID_LLISTA_PREUS_ELE]
            except Exception as e:
                preu = 0 #str(e)
            tarifa['{} {}'.format(periode['name'], periode['tipus'])] =  preu
        resultat[str(tarifa_atr['id'])] = tarifa
        
    return resultat

prod_obj = self.pool.get("product.product")
llistapreus_obj = self.pool.get("product.pricelist")
tarifa_access_obj = self.pool.get("giscedata.polissa.tarifa")
periodes_obj=self.pool.get('giscedata.polissa.tarifa.periodes')
imd_obj = self.pool.get("ir.model.data")

today_date = datetime.today().strftime('%Y-%m-%d')
ctx = {'date': today_date}

PREUS_TARIFA_ELECTRICIDAD = obtener_precios_tarifa_electricidad(cursor, uid, llistapreus_obj,tarifa_access_obj,periodes_obj, context=ctx)

ofertables = $ver_solo_ofertables == 1
price_accuracy = int(config.get('price_accuracy', 6))
categ_id = imd_obj.get_object_reference(cursor, uid, "giscedata_facturacio_indexada", "categ_indexada")[1]
prod_ids = prod_obj.search(cursor, uid, [('categ_id', 'child_of', [categ_id])])
prod_ids.remove(834) #BS
prod_ids.append(2411) #RBS
productes = prod_obj.read(cursor, uid, prod_ids, ['name'])
search_params = [('type', '=', 'sale'), ('compatible_invoicing_modes', '=', 'Indexada')]

if ofertables:
    search_params.extend([('ofertable', '=', True)])
# ids pricelists de tipus venda i indexada
ids_llistes_sale = llistapreus_obj.search(cursor, uid, search_params)
ids_llistes_sale = [2130]
pricelists = llistapreus_obj.read(cursor, uid, ids_llistes_sale,['name','tarifes_atr_compatibles','data_inici_ofertable','data_fi_ofertable','indexed_formula'])
for llista in tqdm(pricelists):
    for tarifa in tarifa_access_obj.read(cursor, uid, llista['tarifes_atr_compatibles'],['name','periodes']):
        linia = crear_linia(llista['name'],llista['data_inici_ofertable'],llista['data_fi_ofertable'],llista['indexed_formula'],tarifa['name'])
        for periode in periodes_obj.read(cursor, uid,tarifa['periodes'],['tipus','name','product_id']):
            if periode['tipus'] != 'te':
                try:
                    preu = llistapreus_obj.price_get(cursor, uid,[llista['id']],periode['product_id'][0],1,context=ctx)[llista['id']]
                except Exception as e:
                    preu = 0
                linia['{periode} {tipus}'.format(periode=periode['name'], tipus='potencia')] = round(preu, price_accuracy)
                linia['Margen {periode} {tipus}'.format(periode=periode['name'], tipus='potencia')] = round(preu-PREUS_TARIFA_ELECTRICIDAD[str(tarifa['id'])]['{} {}'.format(periode['name'], periode['tipus'])], price_accuracy)
        for product in productes:
            try:
                preu = llistapreus_obj.price_get(cursor, uid,[str(llista['id'])],product['id'],1,None,context=ctx)[str(llista['id'])]
            except Exception as e:
                preu = str(e)
            linia[product['name']] = preu#round(preu, price_accuracy)
        res.append(linia)