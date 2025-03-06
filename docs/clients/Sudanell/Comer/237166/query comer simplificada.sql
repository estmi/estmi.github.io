SELECT 
gpt.name as tarifa,
distribuidora.name as distribuidora_name,
cups.name
FROM giscedata_facturacio_factura gff
left join giscedata_cups_ps cups on cups.id = gff.cups_id
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