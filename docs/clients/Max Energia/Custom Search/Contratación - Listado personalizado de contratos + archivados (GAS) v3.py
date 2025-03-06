from tqdm import tqdm
from datetime import datetime
sql = """SELECT
    pol.id as ID,
    pol.name as pol_name,
    titular.name as nombre,
    titular.vat as nif,
    cups.name as cups,
    tarifa.name as tarifa_regulada,
    pol.state as estado_contrato,
    swp.name as proceso,
    sws.name as paso,
    sw.create_date as fecha_proceso,
    pol.data_alta as fecha_inicio_contrato,
    modactiva.data_final as fecha_fin_contrato,

-- Potencies contractades
    pol.pressio as presion,
    pol.caudal_diario as caudal_diario,

    crm_lead.consum_anual as lead_consumo_anual,
    CASE WHEN pol.facturacio_terme_fix = '2' then 'Si' else 'No' end as telemedido,
    cnae.descripcio as cnae,  
    
-- ------
-- Estimacio Consum anual
(
    SELECT SUM(consumo_kwh) FROM giscegas_facturacio_factura fact JOIN account_invoice inv ON inv.id=fact.invoice_id WHERE polissa_id=pol.id AND inv.type='out_invoice' AND fact.tipo_factura='01' AND fact.data_final > date_trunc('month', CURRENT_DATE) - INTERVAL '1 year'
) as activa_kw_consum_facturat_ultims_12_mesos,
(
    SELECT count(*) FROM giscegas_facturacio_factura fact JOIN account_invoice inv ON inv.id=fact.invoice_id WHERE polissa_id=pol.id AND inv.type='out_invoice' AND fact.tipo_factura='01' AND fact.data_final > date_trunc('month', CURRENT_DATE) - INTERVAL '1 year'
) as numero_factures_utilitzades,
-- ------

    distri.name as distribuidora,
    subsistema.description as subsistema,

-- Data activacio prevista pas 02
(
    COALESCE(
        COALESCE(
            (SELECT c102.foreseentransferdate FROM giscegas_atr_02_a2 c102 JOIN giscegas_atr_step_header c102h ON c102h.id=c102.header_id WHERE c102h.sw_id = sw_alta.id LIMIT 1),
            (SELECT c202.foreseentransferdate FROM giscegas_atr_41_a2 c202 JOIN giscegas_atr_step_header c202h ON c202h.id=c202.header_id WHERE c202h.sw_id = sw_alta.id LIMIT 1)
         ),
        (SELECT a302.foreseentransferdate FROM giscegas_atr_38_a2 a302 JOIN giscegas_atr_step_header a302h ON a302h.id=a302.header_id WHERE a302h.sw_id = sw_alta.id LIMIT 1)
     )
)as fecha_activacion_prevista,
-- ------
-- Data baixa prevista pas 11
-- (
--     COALESCE(
--             (SELECT c111.data_activacio FROM giscegas_atr_02_a2s c111 JOIN giscegas_atr_step_header c111h ON c111h.id=c111.header_id WHERE c111h.sw_id = sw_baixa.id),
--             (SELECT c211.data_activacio FROM giscegas_atr_41_a2s c211 JOIN giscegas_atr_step_header c211h ON c211h.id=c211.header_id WHERE c211h.sw_id = sw_baixa.id)
--      )
-- )as fecha_baja_prevista,
-- ------

    cups.direccio as direccio,
    COALESCE(noti.mobile, noti.phone) as telefono_envio,
    llista_preus.name as nombre_tarifa,

-- ------
-- Preus Potencia
    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
      FROM giscegas_facturacio_factura_linia flinia
      JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
      JOIN giscegas_facturacio_factura fact ON fact.polissa_id=pol.id
      JOIN account_invoice inv ON fact.invoice_id=inv.id
      WHERE linia.invoice_id = fact.invoice_id
      AND flinia.tipus = 'fijo'
      AND linia.name = 'P1'
      AND inv.type in ('out_invoice')
    ), 0) as "Preu Fixe Facturat",
-- ------
-- Preus Energia
    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
      FROM giscegas_facturacio_factura_linia flinia
      JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
      JOIN giscegas_facturacio_factura fact ON fact.polissa_id=pol.id
      JOIN account_invoice inv ON fact.invoice_id=inv.id
      WHERE linia.invoice_id = fact.invoice_id
      AND flinia.tipus = 'variable'
      AND linia.name = 'P1'
      AND inv.type in ('out_invoice')
    ), 0) as "Preu Variable Facturat",
-- ------

    fiscal_pos.name as impuesto_hidrocarburos,
    pol.coeficient_k as fee,

    noti.email as email_envio,
    (CASE WHEN sw.additional_info like '%Rebuig%' or sw.additional_info like '%Rechazo%' THEN sw.additional_info ELSE '' END) as motivo_rechazo,
    COALESCE(ccaa.name, rcs.name) as CCAA_provincia,
    pol.consum_anual as pol_consumo_anual,
    pol.consum_anual_oferta_inicial as consumo_anual_oferta_inicial,
    (select data_inici from giscegas_polissa_modcontractual where polissa_id = pol.id and state = 'pendent') as fecha_renovacion,
    (select data_final from giscegas_polissa_modcontractual where polissa_id = pol.id and state = 'pendent') as fecha_final_tras_renovacion,

COALESCE(
	(SELECT pare.name from hr_colaborador_giscegas_polissa colpol
	JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
	JOIN hr_colaborador pare ON pare.id=fill.parent_id
	WHERE colpol.polissa_id = pol.id
	LIMIT 1),
	(SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscegas_polissa colpol
	JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
	WHERE colpol.polissa_id = pol.id)
) as "Colaboradores Padre",
    (
        SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscegas_polissa colpol
        JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
        WHERE colpol.polissa_id = pol.id
    ) as hijos

FROM
    giscegas_polissa pol
    LEFT JOIN giscegas_cups_ps cups ON cups.id=pol.cups
    LEFT JOIN res_partner titular ON titular.id=pol.titular
    LEFT JOIN res_partner distri ON distri.id=pol.distribuidora
    LEFT JOIN product_pricelist llista_preus ON llista_preus.id=pol.llista_preu
    LEFT JOIN giscegas_polissa_tarifa tarifa ON tarifa.id=pol.tarifa
    LEFT JOIN giscegas_polissa_modcontractual modactiva ON modactiva.id=pol.modcontractual_activa

    LEFT JOIN giscegas_atr sw ON sw.id=(select max(sw2.id) from giscegas_atr sw2 where sw2.cups_polissa_id = pol.id)
    LEFT JOIN giscegas_atr_proces swp ON sw.proces_id=swp.id
    LEFT JOIN giscegas_atr_step sws ON sw.step_id=sws.id

    LEFT JOIN res_municipi mun ON cups.id_municipi=mun.id
    LEFT JOIN res_country_state rcs ON rcs.id=mun.state
    LEFT JOIN res_comunitat_autonoma ccaa ON ccaa.id=rcs.comunitat_autonoma
    LEFT JOIN res_subsistemas_electricos subsistema ON subsistema.id=mun.subsistema_id
    LEFT JOIN res_partner_address noti ON noti.id=pol.direccio_notificacio
    LEFT JOIN giscemisc_cnae cnae ON pol.cnae = cnae.id
    LEFT JOIN account_fiscal_position fiscal_pos ON pol.fiscal_position_id = fiscal_pos.id
    LEFT JOIN crm_case crm ON pol.id = crm.polissa_gas_id
    LEFT JOIN giscegas_crm_lead crm_lead ON crm_lead.crm_id = crm.id

    LEFT JOIN giscegas_atr sw_alta ON sw_alta.id=(
        select max(sw3.id)
        from giscegas_atr sw3
        join giscegas_atr_proces p3 ON p3.id=sw3.proces_id
        join giscegas_atr_step s3 ON s3.id=sw3.step_id
        where sw3.cups_polissa_id = pol.id
        and p3.name in ('38', '02', '41')
        and s3.name not in ('a2s', 'a3s')
    )
    LEFT JOIN giscegas_atr sw_baixa ON sw_baixa.id=(
        select max(sw4.id)
        from giscegas_atr sw4
        join giscegas_atr_proces p4 ON p4.id=sw4.proces_id
        join giscegas_atr_step s4 ON s4.id=sw4.step_id
        where sw4.cups_polissa_id = pol.id
        and p4.name in ('38', '02', '41')
        and s4.name in ('a2s', 'a3s')
    )
WHERE
    pol.state in ('esborrany', 'activa', 'baixa', 'baixa2', 'modcontractual','pendent', 'cancelada', 'validar','contracte','tall')
ORDER BY pol.id desc;
"""
cursor.execute(sql)
res = cursor.dictfetchall()

pol_obj = self.pool.get('giscegas.polissa')
tarifa_obj = self.pool.get('giscegas.polissa.tarifa')
periodes_obj = self.pool.get('giscegas.polissa.tarifa.periodes')
pricelist_obj = self.pool.get('product.pricelist')
#{ tarifa_access : {periodes:{tipus:{pricelist:price}}) }
periodes = {}
ctx = {'date': datetime.today().strftime("%Y-%m-%d")}

def ObtenirDades(cursor, uid,tarifa_obj,tarifa_access_id,pricelist_obj,pricelist_act,periodes_obj,ctx, periodes):
    periode_act = {}
    periodes_ids = tarifa_obj.read(cursor, uid,tarifa_access_id, ['periodes'])['periodes']
    for periode in periodes_obj.read(cursor, uid,periodes_ids,['product_id', 'name', 'tipus']):
        if periode['name'] not in periode_act.keys():
            periode_act[periode['name']] = {}
        if periode['tipus'] not in periode_act[periode['name']].keys():
            periode_act[periode['name']][periode['tipus']] = {}
        periode_act[periode['name']][periode['tipus']][pricelist_act] = pricelist_obj.price_get(cursor, uid, [pricelist_act], periode['product_id'][0], 1.0,None, context=ctx)[pricelist_act]

    periodes[tarifa_access_id] = periode_act
#{pricelist:price}
fees ={}
for pol in tqdm(res):
    pol_id = pol['id']
    pol_read = pol_obj.read(cursor,uid,pol_id,['tarifa','llista_preu'])
    if pol_read['tarifa']:
        tarifa_access_id = pol_read['tarifa'][0] #(id, name) #tarifa_obj.read(cursor,uid,pol_read['tarifa'],['periodes'])
        pricelist_act = pol_read['llista_preu'][0]
        if tarifa_access_id not in periodes.keys():
            ObtenirDades(cursor, uid,tarifa_obj,tarifa_access_id,pricelist_obj,pricelist_act,periodes_obj,ctx, periodes)
        elif pricelist_act not in periodes[tarifa_access_id]['P1']['te'].keys():
            ObtenirDades(cursor, uid,tarifa_obj,tarifa_access_id,pricelist_obj,pricelist_act,periodes_obj,ctx, periodes)
        
        if tarifa_access_id in periodes.keys() and pricelist_act in periodes[tarifa_access_id]['P1']['te'].keys():
            periode_act = periodes[tarifa_access_id]    
            pol['Termino Variable Lista precios'] = periode_act['P1']['te'][pricelist_act]
        pol['Termino Fijo Lista precios'] = periode_act['P1']['tp'][pricelist_act]
    if pol['fee'] == 0:
        if pricelist_act in fees.keys():
            pol['fee'] = fees[pricelist_act]
        else:
            fees[pricelist_act] = pricelist_obj.price_get(cursor, uid, [pricelist_act], 1934, 1.0, None,context=ctx)[pricelist_act]
            pol['fee'] = fees[pricelist_act]
