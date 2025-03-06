select gff.id as factura_id,pagador.name as pagador,
case when gff.tipo_factura = '11'
		then 'FRAUDE' else gpt.name end as tarifa,
cups.name
from giscedata_facturacio_factura gff
left join giscedata_cups_ps cups on cups.id = gff.cups_id
inner join account_invoice ai on gff.invoice_id = ai.id
inner join res_partner pagador on pagador.id = ai.partner_id
inner join giscedata_polissa_tarifa gpt on gpt.id = gff.tarifa_acces_id
INNER JOIN account_journal journal on journal.id = ai.journal_id
INNER JOIN ir_sequence serie on serie.id = journal.invoice_sequence_id
left join
(select gffl.factura_id,gffl.tipus,max(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
from giscedata_facturacio_factura_linia gffl
left join account_invoice_line ail on gffl.invoice_line_id = ail.id
where gffl.tipus = 'energia'
group by gffl.factura_id,gffl.tipus) lectures_energia on gff.id = lectures_energia.factura_id
left join
(select gffl.factura_id,gffl.tipus, avg(ail.quantity) as cantidad , sum(ail.price_subtotal) as suma
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
where gffl.tipus = 'altres'
group by gffl.factura_id,gffl.tipus) altres on gff.id = altres.factura_id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P1%'
group by fl.factura_id) p1_activa on p1_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P2%'
group by fl.factura_id) p2_activa on p2_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P3%'
group by fl.factura_id) p3_activa on p3_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P4%'
group by fl.factura_id) p4_activa on p4_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P5%'
group by fl.factura_id) p5_activa on p5_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'energia' and name like '%P6%'
group by fl.factura_id) p6_activa on p6_activa.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P1%'
group by fl.factura_id) p1_reactiva on p1_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P2%'
group by fl.factura_id) p2_reactiva on p2_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P3%'
group by fl.factura_id) p3_reactiva on p3_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P4%'
group by fl.factura_id) p4_reactiva on p4_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P5%'
group by fl.factura_id) p5_reactiva on p5_reactiva.factura_id = gff.id
LEFT JOIN
(select sum(il.quantity) as consumo, fl.factura_id from giscedata_facturacio_factura_linia fl
inner join account_invoice_line il on fl.invoice_line_id = il.id
where fl.tipus = 'reactiva' and name like '%P6%'
group by fl.factura_id) p6_reactiva on p6_reactiva.factura_id = gff.id
WHERE
    ai.date_invoice between to_date('2024-04-16','YYYY-MM-DD') and to_date('2024-05-27','YYYY-MM-DD')
    and gff.facturacio in (1,2,12) and gff.tipo_factura in( '01', '04', '11' )
    and ai.state not in ('draft', 'proforma2', 'cancel')
    and serie.code = 'account.invoice.energia'
order by pagador.name, case when gff.tipo_factura = '11'
		then 'FRAUDE' else gpt.name end;