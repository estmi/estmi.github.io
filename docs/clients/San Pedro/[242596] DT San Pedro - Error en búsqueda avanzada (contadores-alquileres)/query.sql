SELECT 
    compt.name as "N de serie", 
    compt.tensio as "Tensión", 
    p.agree_tipus as "Póliza - Tipo Punto", 
    p.potencia as "Póliza - Potencia contratada (kW)", 
    COALESCE(templ.description, templ.name) as "Producto de alquiler - Descripción", 
    templ.list_price as "Producto de alquiler - Precio de venta"
FROM giscedata_lectures_comptador compt
left join giscedata_polissa p on p.id = compt.polissa
left join product_product prod on compt.product_lloguer_id = prod.id
left join product_template templ on templ.id = prod.product_tmpl_id
where compt.active = 't'
order by compt.name, compt.tensio