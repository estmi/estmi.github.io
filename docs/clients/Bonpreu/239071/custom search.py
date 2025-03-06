from tqdm import tqdm
from collections import OrderedDict

res = []

modcon_obj = self.pool.get('giscedata.polissa.modcontractual')
pol_obj = self.pool.get('giscedata.polissa')

q = pol_obj.q(cursor, uid)
read = q.read(['name', 'cups.name', 'titular.name', 'titular_nif', 'autoconsum_id','autoconsumo', 'data_alta'])
data = read.where([('state', '=', 'activa'), ('autoconsumo','!=','00'), ('id', '<', 500)])


res = []
for reg in tqdm(data,desc='[CS]:Dades autoconsum'):
    d = OrderedDict()
    d['N polissa'] = reg['name']
    d['Titular'] = reg['titular.name']
    d['Titular'] = reg['titular_nif']
    d['CUPS'] = reg['cups.name']
    
    d['Tipus Autoconsum'] = reg['autoconsumo']
    cau_id = reg['autoconsum_id']
    

    if cau_id:
        d['CAU'] = cau_id[1]
        modcon_read = modcon_obj.q(cursor, uid).read(['data_inici', 'autoconsum_id'])
        #modcon_read = modcon_obj.q(cursor, uid).read(['data_inici', 'codi_modificacio', 'autoconsum_id'], order_by = 'codi_modificacio')
        dades_modcons = modcon_read.where([('polissa_id', '=', reg['id'])])
        for modcon in dades_modcons:
            modcon_cau_id = modcon['autoconsum_id']
            if cau_id == modcon_cau_id:
                d['Data Inici Autocon'] = modcon['data_inici']
                break
    else:
        d['CAU'] = ''
        d['Data Inici Autocon'] = ''

    res.append(d)