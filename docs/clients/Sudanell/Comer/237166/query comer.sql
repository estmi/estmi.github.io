SELECT gff.id as factura_id, ai.number, gpt.name as tarifa,
distribuidora.id as distribuidora_id,
distribuidora.name as distribuidora_name,
distribuidora.ref as distribuidora_codi,
serie.code as codi_serie, serie.name as nom_serie,
gpt.id as tarifa_id,
CASE
    WHEN ai.type like '%%_refund' then lectures_energia.cantidad * -1
    ELSE lectures_energia.cantidad
END as le_kw,
CASE
    WHEN ai.type like '%%_refund' then gff.total_energia * -1
    ELSE gff.total_energia * -1
END as le_euros,
CASE
    WHEN ai.type like '%%_refund' then lectures_potencia.cantidad * -1
    ELSE lectures_potencia.cantidad
END as lp_kw,
CASE
    WHEN ai.type like '%%_refund' then gff.total_potencia * -1
    ELSE gff.total_potencia
END as lp_euros,
CASE
    WHEN ai.type like '%%_refund' then lectures_reactiva.cantidad * -1
    ELSE lectures_reactiva.cantidad
END as lr_kw,
CASE
    WHEN ai.type like '%%_refund' then gff.total_reactiva * -1
    ELSE gff.total_reactiva
END as lr_euros,
CASE
    WHEN ai.type like '%%_refund' then gff.total_lloguers * -1
    ELSE gff.total_lloguers
END as lloguers_euros,
CASE
    WHEN ai.type like '%%_refund' then gff.total_exces_potencia * -1
    ELSE gff.total_exces_potencia
END as excesos,
CASE
    WHEN ai.type like '%%_refund' then otros.suma * -1
    ELSE otros.suma
END as otros,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p1_activa.consumo,0) * -1
    ELSE coalesce(p1_activa.consumo,0)
END as p1_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p2_activa.consumo,0) * -1
    ELSE coalesce(p2_activa.consumo,0)
END as p2_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p3_activa.consumo,0) * -1
    ELSE coalesce(p3_activa.consumo,0)
END as p3_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p4_activa.consumo,0) * -1
    ELSE coalesce(p4_activa.consumo,0)
END as p4_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p5_activa.consumo,0) * -1
    ELSE coalesce(p5_activa.consumo,0)
END as p5_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p6_activa.consumo,0) * -1
    ELSE coalesce(p6_activa.consumo,0)
END as p6_consumo,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p1_reactiva.consumo,0) * -1
    ELSE coalesce(p1_reactiva.consumo,0)
END as p1_consumor,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p2_reactiva.consumo,0) * -1
    ELSE coalesce(p2_reactiva.consumo,0)
END as p2_consumor,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p3_reactiva.consumo,0) * -1
    ELSE coalesce(p3_reactiva.consumo,0)
END as p3_consumor,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p4_reactiva.consumo,0) * -1
    ELSE coalesce(p4_reactiva.consumo,0)
END as p4_consumor,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p5_reactiva.consumo,0) * -1
    ELSE coalesce(p5_reactiva.consumo,0)
END as p5_consumor,
CASE
    WHEN ai.type like '%%_refund' then coalesce(p6_reactiva.consumo,0) * -1
    ELSE coalesce(p6_reactiva.consumo,0)
END as p6_consumor,
CASE
    WHEN ai.type like '%%_refund' then IVA.amount * -1
    ELSE IVA.amount
END as iva_amount,
CASE
    WHEN ai.type like '%%_refund' then IVA.base_amount * -1
    ELSE IVA.base_amount
END as iva_base,
CASE
    WHEN ai.type like '%%_refund' then impuesto_electricidad.amount * -1
    ELSE impuesto_electricidad.amount
END as ie_amount,
CASE
    WHEN ai.type like '%%_refund' then ai.amount_tax * -1
    ELSE ai.amount_tax
END as amount_tax,
CASE
    WHEN ai.type like '%%_refund' then ai.amount_total * -1
    ELSE ai.amount_total
END as amount_total
FROM giscedata_facturacio_factura gff
inner join account_invoice ai on gff.invoice_id = ai.id
inner join giscedata_polissa gp on gp.id = gff.polissa_id
inner join product_pricelist gpt on gpt.id = gff.llista_preu
INNER JOIN account_journal journal on journal.id = ai.journal_id
INNER JOIN ir_sequence serie on serie.id = journal.invoice_sequence_id
left join res_partner distribuidora on gp.distribuidora = distribuidora.id
left join
(select gffl.factura_id,gffl.tipus,max(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'energia'
group by gffl.factura_id,gffl.tipus) lectures_energia on gff.id = lectures_energia.factura_id
left join
(select gffl.factura_id,gffl.tipus,avg(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'potencia'
group by gffl.factura_id,gffl.tipus) lectures_potencia on gff.id = lectures_potencia.factura_id
left join
(select gffl.factura_id,gffl.tipus,max(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'reactiva'
group by gffl.factura_id,gffl.tipus) lectures_reactiva on gff.id = lectures_reactiva.factura_id
left join
(select gffl.factura_id,gffl.tipus,max(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'lloguer'
group by gffl.factura_id,gffl.tipus) lloguers on gff.id = lloguers.factura_id
left join
(select gffl.factura_id,gffl.tipus, sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'exces_potencia'
group by gffl.factura_id,gffl.tipus) excesos on gff.id = excesos.factura_id
left join
(select gffl.factura_id,gffl.tipus, sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
left join account_invoice ai ON ai.id = ail.invoice_id
where (gffl.tipus = 'altres' and ai.type like 'out%') or (gffl.tipus = 'subtotal_xml' and ai.type like 'in%')
group by gffl.factura_id,gffl.tipus) otros on gff.id = otros.factura_id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P1%' and fl.isdiscount = False
group by fl.factura_id) p1_activa on p1_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P2%' and fl.isdiscount = False
group by fl.factura_id) p2_activa on p2_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P3%' and fl.isdiscount = False
group by fl.factura_id) p3_activa on p3_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P4%' and fl.isdiscount = False
group by fl.factura_id) p4_activa on p4_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P5%' and fl.isdiscount = False
group by fl.factura_id) p5_activa on p5_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P6%' and fl.isdiscount = False
group by fl.factura_id) p6_activa on p6_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P1%' and fl.isdiscount = False
group by fl.factura_id) p1_reactiva on p1_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P2%' and fl.isdiscount = False
group by fl.factura_id) p2_reactiva on p2_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P3%' and fl.isdiscount = False
group by fl.factura_id) p3_reactiva on p3_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P4%' and fl.isdiscount = False
group by fl.factura_id) p4_reactiva on p4_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P5%' and fl.isdiscount = False
group by fl.factura_id) p5_reactiva on p5_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P6%' and fl.isdiscount = False
group by fl.factura_id) p6_reactiva on p6_reactiva.factura_id = gff.id
left join
(select invoice_id,amount from account_invoice_tax where name like '%electricidad%') impuesto_electricidad
on impuesto_electricidad.invoice_id = ai.id
left join
(select invoice_id,sum(base_amount) as base_amount,
sum(amount) as amount from account_invoice_tax where name like '%IVA%' group by invoice_id) IVA
on IVA.invoice_id = ai.id
WHERE
    ai.date_invoice  between to_date('2024-04-16','YYYY-MM-DD') and to_date('2024-05-27','YYYY-MM-DD')
    and gff.facturacio in (1,2,12) and gff.tipo_factura in ('01', '11')
    and ai.state not in ('draft','proforma2','cancel')
    and serie.code = 'account.invoice.energia'
order by distribuidora.id,gpt.id;