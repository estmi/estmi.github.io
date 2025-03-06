   

fact_obj = c.model('giscedata.facturacio.factura')
pol_obj = c.model('giscedata.polissa')
mandate_obj = c.model('payment.mandate')
fact_names = ['FE24011534',
'FE24011541',
'FE24011542',
'FE24011616',
'FE24011617',
'FE24011618',
'FE24011619',
'FE24011620',
'FE24011623',
'FE24011624',
'FE24011625',
'FE24011627',
'FE24011628',
'FE24011629',
'FE24011630',
'FE24011631',
'FE24011632',
'FE24011633',
'FE24011634',
'FE24011635',
'FE24011636',
'FE24011637',
'FE24011638',
'FE24011639',
'FE24011640',
'FE24011641',
'FE24011643',
'FE24011644',
'FE24011645',
'FE24011646',
'FE24011647',
'FE24011649',
'FE24011650',
'FE24011652',
'FE24011653',
'FE24011654',
'FE24011655',
'FE24011656',
'FE24011657',
'FE24011658',
'FE24011660',
'FE24011661',
'FE24011662',
'FE24011663',
'FE24011664',
'FE24011666',
'FE24011667',
'FE24011668',
'FE24011669',
'FE24011671',
'FE24011672',
'FE24011673',
'FE24011674',
'FE24011675',
'FE24011676',
'FE24011677',
'FE24011678',
'FE24011679',
'FE24011680',
'FE24011681',
'FE24011682',
'FE24011683',
'FE24011684',
'FE24011685',
'FE24011686',
'FE24011687',
'FE24011688',
'FE24011689',
'FE24011690',
'FE24011691',
'FE24011693',
'FE24011694',
'FE24011695',
'FE24011696',
'FE24011697',
'FE24011698',
'FE24011699',
'FE24011700',
'FE24011701',
'FE24011702',
'FE24011703',
'FE24011704',
'FE24011705',
'FE24011706']
ids_fact = fact_obj.search([('number','in',fact_names)])

for fact in fact_obj.read(ids_fact, ['data_final', 'polissa_id']):
   polissa_id = fact['polissa_id'][0]
   factura_id = fact['id']
   data_final_fact = fact['data_final']
   
   polissa = pol_obj.browse(polissa_id, context={'date':data_final_fact})
   
   reference = 'giscedata.polissa,%s' % polissa.id
   search_params = [('reference', '=', reference), ('debtor_iban', '=', polissa.bank.iban)]
   
   mandate_ids = mandate_obj.search(search_params, limit=1)

   mandate_id = mandate_ids[0]


   #fact_obj.write(factura_id, {'mandate_id':mandate_id})
   print('fact: {fact} -> pol: {pol} - mandat: {mandat}/{mandats}'.format(fact=factura_id, pol=polissa_id,mandat=mandate_id,mandats=len(mandate_ids)))