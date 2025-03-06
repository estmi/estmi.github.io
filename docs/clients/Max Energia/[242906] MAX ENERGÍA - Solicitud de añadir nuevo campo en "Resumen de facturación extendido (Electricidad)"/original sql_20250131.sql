
SELECT 
    fact.id as "ID Factura",
    cups.name as "CUPS",
    part.name as "Client",
    part.vat as "CIF",
    tarifaatr.name as "Tarifa",
    empl.name as "Comercial",
    pol.name as "Contracte",
       
    llista.name as "Producte (Tarifa Comer)",
    COALESCE( to_char(inv.date_invoice::date, 'DD/MM/YYYY'), ' ') as "F.Factura",
    COALESCE( to_char(inv.date_due::date, 'DD/MM/YYYY'), ' ') as "F.Vencimiento",
    -- Parte nueva
    CASE
         WHEN inv.residual > 0 THEN null
         ELSE (acc.date)
    END as "F. Pago Factura",
    -- Fin parte nueva
    COALESCE( inv.number, ' ') as "Num.Factura",
    inv.state as "Estado factura",
    COALESCE( to_char(fact.data_inici::date, 'DD/MM/YYYY'), ' ') as "F.Inicio",
    COALESCE( to_char(fact.data_final::date, 'DD/MM/YYYY'), ' ') as "F.Fin",
    
    CASE 
        WHEN inv.type in ('out_refund', 'in_refund') THEN inv.amount_untaxed * -1
        ELSE inv.amount_untaxed
     END as "Base imponible",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN  inv.amount_tax  * -1
        ELSE  inv.amount_tax 
    END as "Impuestos",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN  inv.amount_total  * -1
        ELSE  inv.amount_total
    END as "Total",

    inv.residual as "Residual pendent",

    fact.energia_kwh,

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P1'
    ), 0) as "Preu Energia P1",

   COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P2'
    ), 0) as "Preu Energia P2",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P3'
    ), 0) as "Preu Energia P3",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P4'
    ), 0) as "Preu Energia P4",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P5'
    ), 0) as "Preu Energia P5",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND linia.name = 'P6'
    ), 0) as "Preu Energia P6",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P1'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P1'
 ), 0)
    END as "Energia P1 (kWh)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P2'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P2'
 ), 0)
    END as "Energia P2 (kWh)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P3'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P3'
 ), 0)
    END as "Energia P3 (kWh)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P4'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P4'
 ), 0)
    END as "Energia P4 (kWh)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P5'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P5'
 ), 0)
    END as "Energia P5 (kWh)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT SUM(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'energia'
AND linia.name = 'P6'
), 0)
        ELSE COALESCE( (SELECT SUM(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'energia'
 AND linia.name = 'P6'
 ), 0)
    END as "Energia P6 (kWh)",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P1'
    ), 0) as "Preu Potencia P1",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P2'
    ), 0) as "Preu Potencia P2",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P3'
    ), 0) as "Preu Potencia P3",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P4'
    ), 0) as "Preu Potencia P4",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P5'
    ), 0) as "Preu Potencia P5",

    COALESCE( (SELECT AVG(flinia.price_unit_multi)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'potencia'
    AND linia.name = 'P6'
    ), 0) as "Preu Potencia P6",

    fact.is_profiled as "Perfilada",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P1'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P1'
 ), 0)
    	END as "Potencia P1 (KW)",
    	
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P2'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P2'
 ), 0)
    	END as "Potencia P2 (KW)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P3'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P3'
 ), 0)
    	END as "Potencia P3 (KW)",
    	
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P4'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P4'
 ), 0)
    	END as "Potencia P4 (KW)",
    	
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P5'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P5'
 ), 0)
    	END as "Potencia P5 (KW)",
    	
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
      COALESCE( (SELECT  AVG(linia.quantity * -1)
FROM giscedata_facturacio_factura_linia flinia
JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
WHERE linia.invoice_id = inv.id
AND flinia.tipus = 'potencia'
AND linia.name = 'P6'
), 0)
        ELSE COALESCE( (SELECT  AVG(linia.quantity)
 FROM giscedata_facturacio_factura_linia flinia
 JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
 WHERE linia.invoice_id = inv.id
 AND flinia.tipus = 'potencia'
 AND linia.name = 'P6'
 ), 0)
    	END as "Potencia P6 (KW)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            ), 0)
    END as "Activa (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            ), 0)
    END as "Potencia (euros)",           

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'exces_potencia'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'exces_potencia'
            ), 0) 
    END as "Excesos Potencia (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0)
    END as "Reactiva (euros)",

    COALESCE( irectificada.number, ' ') as "Regularizacion",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(base * -1)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
        ELSE COALESCE( (SELECT sum(base)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0) 
    END as "Base Impuesto Electrico",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(amount * -1)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
        ELSE COALESCE( (SELECT sum(amount)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
    END as "Impuesto Electrico",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'lloguer'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'lloguer'
            ), 0)
    END as "Lloguers (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code like 'CON%'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code like 'CON%'
            ), 0)
    END as "Altres (Derechos Dist.) (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'HH01'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'HH01'
            ), 0)
    END "Altres (Descompte) (euros)",

    COALESCE( mun.name, ' ') as "Municipio",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P1%'
    ), 0) as "Reactiva P1 (kVar)",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P2%'
    ), 0) as "Reactiva P2 (kVar)",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P3%'
    ), 0) as "Reactiva P3 (kVar)",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P4%'
    ), 0) as "Reactiva P4 (kVar)",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P5%'
    ), 0) as "Reactiva P5 (kVar)",

    COALESCE( (SELECT avg(flect.lect_actual)
    FROM giscedata_facturacio_lectures_energia flect
    WHERE flect.factura_id = fact.id
    AND flect.tipus = 'reactiva'
    AND flect.name like '%P6%'
    ), 0) as "Reactiva P6 (kVar)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P1%'
    ), 0) as "Maximetre P1 (kW)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P2%'
    ), 0) as "Maximetre P2 (kW)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P3%'
    ), 0) as "Maximetre P3 (kW)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P4%'
    ), 0) as "Maximetre P4 (kW)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P5%'
    ), 0) as "Maximetre P5 (kW)",

    COALESCE( (SELECT avg(flect.pot_maximetre)
    FROM giscedata_facturacio_lectures_potencia flect
    WHERE flect.factura_id = fact.id
    AND flect.name like '%P6%'
    ), 0) as "Maximetre P6 (kW)",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P1%'), 0) AS "Lra. Ant. P1",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P1%'), 0) AS "Lra. Act. P1",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P2%'), 0) AS "Lra. Ant. P2",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P2%'), 0) AS "Lra. Act. P2",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P3%'), 0) AS "Lra. Ant. P3",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P3%'), 0) AS "Lra. Act. P3",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P4%'), 0) AS "Lra. Ant. P4",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P4%'), 0) AS "Lra. Act. P4",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P5%'), 0) AS "Lra. Ant. P5",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P5%'), 0) AS "Lra. Act. P5",

    COALESCE((SELECT avg(lect.lect_anterior)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P6%'), 0) AS "Lra. Ant. P6",

    COALESCE((SELECT avg(lect.lect_actual)
    FROM giscedata_facturacio_lectures_energia AS lect
    WHERE lect.factura_id = fact.id
    AND lect.tipus = 'activa'
    AND lect.magnitud = 'AE'
    AND lect.name like '%P6%'), 0) AS "Lra. Act. P6",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%potencia%'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%potencia%'
            ), 0)
    END as "Otros (Descuento Cargos Potencia) (euros)",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN            
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%energia%'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%energia%'
            ), 0)
    END as "Otros (Descuento Cargos Energia) (euros)",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
    END as "Otros (Descuento Cargos) (euros)",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN            
            COALESCE( (SELECT sum(round(-1 * linia.price_unit * linia.quantity, 2))
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id AND linia.discount != 0
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
        ELSE COALESCE( (SELECT sum(round(linia.price_unit * linia.quantity, 2))
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id AND linia.discount != 0
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
    END as"Otros (Descuento Cargos ya incluidos precio final) (euros)",

    COALESCE( (SELECT count(*)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    JOIN product_uom uom ON uom.id=linia.uos_id
    JOIN product_product prod ON prod.id = linia.product_id
    WHERE linia.invoice_id = inv.id
    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
    AND prod.default_code = 'DESC1721'
    ), 0) as "Otros (Numero de lineas de Cargos)",

   COALESCE( (SELECT sum(linia.quantity) * -1
   FROM giscedata_facturacio_factura_linia flinia
   JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
   JOIN product_product prod ON prod.id = linia.product_id
   WHERE linia.invoice_id = inv.id 
   AND flinia.tipus = 'generacio' AND prod.default_code  !='SEA'
   ), 0)  as  "kw facturados como excedentes autoconsumo",

   COALESCE( (SELECT sum(linia.price_subtotal) * -1
   FROM giscedata_facturacio_factura_linia flinia
   JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
   JOIN product_product prod ON prod.id = linia.product_id
   WHERE linia.invoice_id = inv.id 
   AND flinia.tipus = 'generacio'
   ), 0)  as  "Importe total de generacion",
   
   COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P1'
    ), 0) as "Preu Excedents P1",

   COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P2'
    ), 0) as "Preu Excedents P2",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P3'
    ), 0) as "Preu Excedents P3",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P4'
    ), 0) as "Preu Excedents P4",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P5'
    ), 0) as "Preu Excedents P5",

    COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P6'
    ), 0) as "Preu Excedents P6",
    
    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P1'
    ), 0) as "Excedents P1 (kW)",

    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P2'
    ), 0) as "Excedents P2 (kW)",

    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P3'
    ), 0) as "Excedents P3 (kW)",

    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P4'
    ), 0) as "Excedents P4 (kW)",

    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P5'
    ), 0) as "Excedents P5 (kW)",

    COALESCE( (SELECT SUM(linia.quantity)
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'generacio'
    AND linia.name = 'P6'
    ), 0) as "Excedents P6 (kW)",

    COALESCE( (SELECT sum(linia.price_subtotal) * -1
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    JOIN product_product prod ON prod.id = linia.product_id 
    WHERE linia.invoice_id = inv.id
    AND flinia.tipus = 'energia'
    AND prod.default_code = 'RMAG'
    ), 0) as "Mecanismo de Ajuste",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN            
            COALESCE( (SELECT -1 * SUM(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id 
            AND prod.default_code='SEA'
            ), 0)
        ELSE COALESCE( (SELECT  SUM(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id 
            AND prod.default_code='SEA'
            ), 0)
    END AS "Saldo excedents autoconsum",   
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'RBS'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'RBS'
            ), 0)
    END as "Altres (Bono social) (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code in ('SPA')
            AND linia.name != ('SPA PLUS')
            AND linia.name != ('SAH')
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code in ('SPA')
            AND linia.name != ('SPA PLUS')
            AND linia.name != ('SAH')
            ), 0)
    END as "SPA (euros)",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('SPA PLUS') OR prod.default_code in ('SPA PLUS'))
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('SPA PLUS') OR prod.default_code in ('SPA PLUS'))
            ), 0)
    END as "SPA PLUS (euros)",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('MTN') OR prod.default_code in ('MTN'))
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('MTN') OR prod.default_code in ('MTN'))
            ), 0)
    END as "MTN (euros)",
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('SAH') OR prod.default_code in ('SAH'))
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('SAH') OR prod.default_code in ('SAH'))
            ), 0)
    END as "SAH (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('GESP') OR prod.default_code in ('GESP'))
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND (linia.name = ('GESP') OR prod.default_code in ('GESP'))
            ), 0)
    END as "GESP (euros)",
    
    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT sum(linia.price_subtotal * -1)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
            AND linia.name not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
            AND prod.default_code not like 'CON%'
            ), 0)
        ELSE COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
            AND linia.name not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
            AND prod.default_code not like 'CON%'
            ), 0)
    END as "Otros (No clasificados) (euros)",
    pm.name as "Grupo de Pago",
    CASE
        WHEN modcon.facturar_gdos THEN 'Si'
        ELSE CASE WHEN modcon.facturar_gdos is not Null THEN 'No' 
                             ELSE CASE WHEN pol.facturar_gdos THEN 'Si'
                                                   ELSE 'No'
                             END
                  END                  
        END as "Se factura GdOs",

    COALESCE( (SELECT string_agg(linia.name, ',')
    FROM giscedata_facturacio_factura_linia flinia
    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
    JOIN product_uom uom ON uom.id=linia.uos_id
    JOIN product_product prod ON prod.id = linia.product_id
    WHERE linia.invoice_id = inv.id
    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
    AND prod.default_code = 'GESP'
   ), '-')  as "Servicio de gestion facturado",

    CASE
        WHEN inv.type in ('out_refund', 'in_refund') THEN        
            COALESCE( (SELECT string_agg((linia.price_unit * -1)::varchar, ',')
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'GESP'
            ))
        ELSE COALESCE( (SELECT string_agg((linia.price_unit * 1)::varchar, ',')
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'GESP'
            ))
    END as "Importe diario servicio gestión",
    
    pol.pending_amount as "Cantidad pendiente",
    COALESCE( mandate.name, ' ') as "Mandato",
    COALESCE( to_char(mandate.date::date, 'DD/MM/YYYY'), ' ') as "Fecha Firma Mandato",
    mandate.signed as "Check de Firmado (Mandato)",
    condicions_generals.name as "Condiciones generales",
    (
      SELECT categoria.name
      FROM giscedata_polissa_category categoria
      JOIN giscedata_polissa_category_rel rel ON rel.category_id = categoria.id AND rel.polissa_id = pol.id
    ) as "Categoria",
    cn.name AS "CNAE",
    pol.consum_anual_oferta_inicial as "Consumo anual oferta inicial",
    
    (
      SELECT lec_orig_p1.name
    	FROM giscedata_facturacio_factura fact_sub
            	LEFT JOIN giscedata_facturacio_lectures_energia lec_ene_p1 ON lec_ene_p1.factura_id=fact_sub.id
            	LEFT JOIN giscedata_lectures_origen lec_orig_p1 ON lec_orig_p1.id = lec_ene_p1.origen_id
    	WHERE 
    		fact_sub.id = fact.id
    		AND lec_ene_p1.name ILIKE '%P1%'
    		AND lec_ene_p1.tipus = 'activa'
    	LIMIT 1
    )  AS "Origen Actual",
    multipunt.name as "Multipunto",
    descompte_bateria.import as "Total importe BV",
    comp.name as "Compania",
    pol.mode_facturacio as "Modo de facturación",
    (
    	select string_agg(ait."name", ',') 
		from account_invoice_tax ait
		where name not ilike '%especi%electri%' and ait.invoice_id = inv.id
	) as impuestos_factura,
    (
		select name from account_fiscal_position afp
		where afp.id = inv.fiscal_position
	) as posicion_fiscal
FROM
        giscedata_facturacio_factura fact
        LEFT JOIN account_invoice inv ON inv.id=fact.invoice_id
-- Parte nueva
LEFT JOIN (
        SELECT DISTINCT ON (acc2.ref) acc2.*
        FROM account_move_line acc2
        WHERE acc2.reconcile_id IS NOT NULL
    ORDER BY acc2.ref
) acc ON (acc.ref = inv.number AND acc.move_id != inv.move_id)
-- Fin Parte
        LEFT JOIN giscedata_polissa_tarifa tarifaatr ON tarifaatr.id=fact.tarifa_acces_id
        LEFT JOIN giscedata_polissa pol ON pol.id=fact.polissa_id
        LEFT JOIN res_company comp ON comp.id=inv.company_id
        LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
        LEFT JOIN giscedata_polissa_condicions_generals condicions_generals ON condicions_generals.id=pol.condicions_generals_id
        LEFT JOIN product_pricelist llista ON llista.id=fact.llista_preu
        LEFT JOIN res_partner part ON part.id=inv.partner_id
        LEFT JOIN res_municipi mun ON mun.id=cups.id_municipi
        LEFT JOIN giscedata_facturacio_factura as rectificada ON rectificada.id=fact.ref
        LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
        LEFT JOIN payment_mode pm ON pm.id=fact.payment_mode_id
        LEFT JOIN payment_mandate AS mandate ON mandate.id = inv.mandate_id
        LEFT JOIN giscemisc_cnae cn ON cn.id = pol.cnae  
        LEFT JOIN giscedata_polissa_modcontractual modcon ON (
            pol.id = modcon.polissa_id
        AND
            (
                modcon.data_inici <= fact.data_final AND modcon.data_final >= fact.data_final
            )
        )
        LEFT JOIN (
              SELECT fact.id, sum(des.import) as "import"
              FROM giscedata_bateria_virtual_polissa pol
              LEFT JOIN giscedata_bateria_virtual bat ON bat.id = pol.bateria_id
              LEFT JOIN giscedata_bateria_virtual_polissa_descompte des ON des.bateria_id = bat.id AND des.bateria_polissa_id = pol.id
              LEFT JOIN giscedata_facturacio_factura fact ON fact.polissa_id = pol.polissa_id
             GROUP BY fact.id
        ) as descompte_bateria ON descompte_bateria.id = fact.id
        LEFT JOIN hr_employee empl ON empl.id = pol.comercial_id
        LEFT JOIN giscedata_polissa_multipunt multipunt ON multipunt.id = pol.multipunt_id 
WHERE
        inv.type in ('out_invoice', 'out_refund')
        AND inv.state in ('paid', 'open', 'draft', 'grouped_proforma', 'proforma', 'proforma2')
        AND inv.date_invoice BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'           