from erppeek import Client
c = Client('http://localhost:12000', 'electrica_catral', 'gisce')
fact_obj = c.GiscedataFacturacioFactura
ids = fact_obj.search([('date_invoice','=', '16-01-2025')])
len(ids)
from tqdm import tqdm
for id in tqdm(ids):
    fact_obj.rectificar([id], 'R', {})
