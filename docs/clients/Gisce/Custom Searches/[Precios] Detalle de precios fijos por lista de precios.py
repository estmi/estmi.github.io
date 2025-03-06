
#def customSearch(self, cursor, uid, context=None):
# [INFO] Variables disponibles a l'scope: self (objecte custom.search), cursor, uid.
# Variable obligatoria de 'retorn': res.
# Format de la variable: Llistat de diccionaris on la clau es el camp i el valor, doncs el valor.
# Exemple:
# res = [{'name': 'GISCE', 'phone': '972 21 73 84'}]
from datetime import datetime
from tools import config
res = []
def crear_linia( name,di_ofertable, df_ofertable, tarifa_acces=''):
    from collections import OrderedDict    
    ord =  OrderedDict()
    ord['Tarifa Comercial'] = name
    ord['Data Inici'] = di_ofertable
    ord['Data Fi'] = df_ofertable
    ord['Tarifa Acces'] = tarifa_acces
    ord['P1 energia']=0
    ord['P2 energia']=0
    ord['P3 energia']=0
    ord['P4 energia']=0
    ord['P5 energia']=0
    ord['P6 energia']=0
    ord['P1 potencia']=0
    ord['P2 potencia']=0
    ord['P3 potencia']=0
    ord['P4 potencia']=0
    ord['P5 potencia']=0
    ord['P6 potencia']=0

    return ord

prod_obj = self.pool.get("product.product")
llistapreus_obj = self.pool.get("product.pricelist")
tarifa_access_obj = self.pool.get("giscedata.polissa.tarifa")
periodes_obj=self.pool.get('giscedata.polissa.tarifa.periodes')

ofertables = $ver_solo_ofertables == 1

price_accuracy = int(config.get('price_accuracy', 6))

search_params = [('type', '=', 'sale'), ('compatible_invoicing_modes', '=', 'ATR')]
today_date = datetime.today().strftime('%Y-%m-%d')
ctx = {'date': today_date}
if ofertables:
    search_params.extend(['|',('data_inici_ofertable','=',False),('data_inici_ofertable','<=',today_date),'|',('data_fi_ofertable','=',False),('data_fi_ofertable','>=',today_date)])

# ids pricelists de tipus venda i ATR preu Fix
ids_llistes_sale = llistapreus_obj.search(cursor, uid, search_params)



for llista in llistapreus_obj.read(cursor, uid, ids_llistes_sale,['name','tarifes_atr_compatibles','data_inici_ofertable','data_fi_ofertable']):
    for tarifa in tarifa_access_obj.read(cursor, uid, llista['tarifes_atr_compatibles'],['name','periodes']):
        linia = crear_linia(llista['name'],llista['data_inici_ofertable'],llista['data_fi_ofertable'],tarifa['name'])
        
        for periode in periodes_obj.read(cursor, uid,tarifa['periodes'],['tipus','name','product_id']):
            try:
                preu = llistapreus_obj.price_get(cursor, uid,[llista['id']],periode['product_id'][0],1,context=ctx)[llista['id']]
            except Exception as e:
                preu = 0
            linia['{periode} {tipus}'.format(periode=periode['name'], tipus='potencia' if periode['tipus'] == 'tp' else 'energia')] = round(preu, price_accuracy)

        res.append(linia)