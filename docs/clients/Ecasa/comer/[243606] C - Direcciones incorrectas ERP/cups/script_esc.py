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

ids = cups_obj.search([('es', 'ilike', '%ESC%')])

patt = re.compile('(\s*)ESC(\s*)')
patt2 = re.compile('(\s*)ESC.(\s*)')
if True:
#with open("cups_comer_esc.txt", "w") as f:
    #f.write('cups;orig;new\n')
    for cups_data in tqdm(cups_obj.read(ids, ['es','name'])):
        new_es = patt.sub('', cups_data['es'].upper()).strip()
        if not is_float(new_es) or '.' in new_es:
            new_es2 = patt2.sub('', cups_data['es'].upper()).strip()
            if len(new_es2)>=1:
                new_es=new_es2
        print({'es':new_es, 'orig': cups_data['es']})
        if len(new_es)==0:
            new_es = cups_data['es'].upper()
        #f.write('{};{};{}\n'.format(cups_data['name'], cups_data['es'], new_es))
        cups_obj.write([cups_data['id']], {'es':new_es})