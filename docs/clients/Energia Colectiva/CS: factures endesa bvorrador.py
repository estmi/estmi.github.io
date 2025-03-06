fact_obj = self.pool.get('giscedata.facturacio.factura')
fact_q = fact_obj.q(cursor, uid)
fact_read = fact_q.read(['id','data_inici','data_final','state','amount_total','number','tipo_factura', 'tipo_rectificadora'])
sql = """
SELECT
    fact.id, fact.data_inici, fact.data_final, fact.polissa_id
FROM giscedata_facturacio_factura fact 
LEFT JOIN account_invoice inv on inv.id = fact.invoice_id 
LEFT JOIN giscedata_facturacio_importacio_linia_factura fact_f1_rel on fact.id = fact_f1_rel.factura_id 
WHERE
    inv.type = 'in_invoice'
    AND fact_f1_rel.id is null
    AND inv.state = 'draft'
    AND inv.journal_id != 101"""
cursor.execute(sql)
data = cursor.dictfetchall()
res = []
for fact_data in data:
    fact_id = fact_data['id']
    fact_data_inici = fact_data['data_inici']
    fact_data_final = fact_data['data_final']
    facts = fact_read.where(
        [
            ('data_inici','=',fact_data_inici),
            ('data_final','=',fact_data_final),
            ('type','in',('in_invoice', 'in_refund')),
            ('polissa_id','=', fact_data['polissa_id']),
            ('id','!=',fact_id)
         ])
    all_paid = True
    idx = 0
    price = ''
    N = 0
    A = 0
    R = 0
    while idx < len(facts):
        all_paid = facts[idx]['state'] == 'paid'
        price+=' | (id:{id}) {number} [{state}][{type_rect}]'.format(number=facts[idx]['number'], id=facts[idx]['id'], state=facts[idx]['state'], type_rect=facts[idx]['tipo_rectificadora'])
        if facts[idx]['tipo_rectificadora'] == 'N':
            N+=1
        elif facts[idx]['tipo_rectificadora'] == 'BRA':
            A +=1
        elif facts[idx]['tipo_rectificadora'] == 'RA':
            R+=1
        idx+=1
    price=price[3::]
    fact_data['price']= price
    fact_data['A'] = A
    fact_data['N'] = N
    fact_data['R'] = R

    if all_paid:
        res.append(fact_data)
    