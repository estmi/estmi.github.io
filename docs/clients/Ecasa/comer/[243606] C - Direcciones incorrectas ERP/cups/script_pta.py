from erppeek import Client
from tqdm import tqdm
import re, numbers
def is_float(v):
    try:
        f=float(v)
        if f<0:
            return False
    except ValueError:
        return False
    return True
c = Client('http://localhost:12000', 'ecasa_comer', 'gisce','atrallum.eca')

cups_obj = c.model('giscedata.cups.ps')

ids = cups_obj.search([('pu', 'ilike', '%PTA%')])

patt = re.compile('(\s*)PTA(\s*)')
patt2 = re.compile('(\s*)PTA.(\s*)')
with open("file2.txt", "w") as f:
    f.write('cups;orig;new\n')
    for cups_data in tqdm(cups_obj.read(ids, ['pu','name'])):
        new_es = patt.sub('', cups_data['pu'].upper()).strip()
        if not is_float(new_es) or '.' in new_es:
            new_es2 = patt2.sub('', cups_data['pu'].upper()).strip()
            if len(new_es2)>=1:
                new_es=new_es2
        print({'pu':new_es, 'orig': cups_data['pu']})
        if len(new_es)==0:
            new_es = cups_data['pu'].upper()
        f.write('{};{};{}\n'.format(cups_data['name'], cups_data['pu'], new_es))
        #cups_obj.write([cups_data['id']], {'es':new_es})