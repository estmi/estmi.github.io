SELECT 
            fact.id as "ID Factura",
            cups.name as "CUPS",
            part.name as "Client",
            part.vat as "CIF",
            tarifaatr.name as "Tarifa",
            pol.name as "Contracte",
            llista.name as "Producte (Tarifa Comer)",
            COALESCE( to_char(inv.date_invoice::date, 'DD/MM/YYYY'), ' ') as "F.Factura",
            COALESCE( to_char(inv.date_due::date, 'DD/MM/YYYY'), ' ') as "F.Vencimiento",
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

            fact.energia_kwh,
 
            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P1'
            ), 0) as "Preu Energia P1",
        
           COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P2'
            ), 0) as "Preu Energia P2",
        
            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P3'
            ), 0) as "Preu Energia P3",
        
            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P4'
            ), 0) as "Preu Energia P4",
        
            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P5'
            ), 0) as "Preu Energia P5",
        
            COALESCE( (SELECT AVG(linia.price_unit)
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
            END "Altres (Descompte T.Rellotge) (euros)",
        
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
-- END MAXIMETRES


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

            gp.name as "Grupo.Cobro",
            
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
                    AND (prod.default_code not in ('RBS', 'HH01', 'DESC1721')
                    AND prod.default_code not like 'CON%'
                    OR prod.default_code is Null)
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND (prod.default_code not in ('RBS', 'HH01', 'DESC1721')
                    AND prod.default_code not like 'CON%'
                    OR prod.default_code is Null)
                    ), 0)
            END as "Otros (No clasificados) (euros)",

COALESCE(
    (
        SELECT bank.iban
        FROM res_partner_bank bank
        JOIN giscedata_polissa polissa ON polissa.bank = bank.id
        WHERE polissa.id = pol.id
    ), '0'
) AS "IBAN",

        inv.mandate_id as "Referencia Mandato",

COALESCE(
    (
        SELECT lot.name
        FROM giscedata_facturacio_lot lot
        JOIN giscedata_facturacio_factura factura ON factura.lot_facturacio = lot.id
        WHERE factura.id = fact.id
    ), '0'
) AS "Lote factura generada",
 COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0) as "Preu Generacio P1",

           COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0) as "Preu Generacio P2",

            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0) as "Preu Generacio P3",

            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0) as "Preu Generacio P4",

            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0) as "Preu Generacio P5",

            COALESCE( (SELECT AVG(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0) as "Preu Generacio P6",
            
            CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P1'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P1'
                ), 0) 
           END as "Generacio P1 (kWh)",

            CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P2'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P2'
                ), 0) 
           END as "Generacio P2 (kWh)",

            CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P3'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P3'
                ), 0) 
           END as "Generacio P3 (kWh)",

            CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P4'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P4'
                ), 0) 
           END as "Generacio P4 (kWh)",

           CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P5'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P5'
                ), 0) 
           END as "Generacio P5 (kWh)",

            CASE
            WHEN inv.type in ('out_refund', 'in_refund') THEN
                COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P6'
                ), 0) 
            ELSE COALESCE( (SELECT sum(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P6'
                ), 0) 
           END as "Generacio P6 (kWh)",

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
                    COALESCE( (SELECT -1 * SUM(linia.price_subtotal)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id 
                    AND prod.default_code='PBV'
                    ), 0)
                ELSE COALESCE( (SELECT  SUM(linia.price_subtotal)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id 
                    AND prod.default_code='PBV'
                    ), 0)
            END AS "Descuento Bateria Virtual",
            pol.autoconsumo AS tipo_autoconsumo,
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
        descompte_bateria.import as "Total import BV",
        inv.residual as "Residual",
        COALESCE((SELECT STRING_AGG(name, ',')
         FROM account_invoice_tax 
         WHERE invoice_id = inv.id AND name like '%electric%'), 'IEE 0') as "Nombre Impuesto Electrico",
        (SELECT STRING_AGG(name, ',')
         FROM account_invoice_tax 
         WHERE invoice_id = inv.id AND name like '%IVA%')
         as "Nombre IVA",
         COALESCE((select base_price from product_pricelist_item ppi left join product_pricelist_version ppv on ppv.id = ppi.price_version_id where product_id = (select id from product_product where default_code = 'gdos') and ppv.pricelist_id = fact.llista_preu), 0) as "Precio GDOS",
        CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN        
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'TFIJOFRANK'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'TFIJOFRANK'
                    ), 0)
            END as "Termino fijo (Servicio contratado)",
        CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN        
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code like 'PPDISC_'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscedata_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code like 'PPDISC_'
                    ), 0)
            END as "Descuento Mensual (Servicio Contratado)" 
        FROM
                giscedata_facturacio_factura fact
                LEFT JOIN account_invoice inv ON inv.id=fact.invoice_id
                LEFT JOIN giscedata_polissa_tarifa tarifaatr ON tarifaatr.id=fact.tarifa_acces_id
                LEFT JOIN giscedata_polissa pol ON pol.id=fact.polissa_id
                LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
                LEFT JOIN product_pricelist llista ON llista.id=fact.llista_preu
                LEFT JOIN res_partner part ON part.id=inv.partner_id
                LEFT JOIN res_municipi mun ON mun.id=cups.id_municipi
                LEFT JOIN (
                    SELECT fact.id, sum(des.import) as "import"
                    FROM giscedata_bateria_virtual_polissa pol
                    LEFT JOIN giscedata_bateria_virtual bat ON bat.id = pol.bateria_id
                    LEFT JOIN giscedata_bateria_virtual_polissa_descompte des ON des.bateria_id = bat.id AND des.bateria_polissa_id = pol.id
                    LEFT JOIN giscedata_facturacio_factura fact ON fact.polissa_id = pol.polissa_id
                    GROUP BY fact.id
                ) as descompte_bateria ON descompte_bateria.id = fact.id
                LEFT JOIN giscedata_facturacio_factura as rectificada ON rectificada.id=fact.ref
                LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
                LEFT JOIN payment_mode as gp ON fact.payment_mode_id = gp.id
        WHERE
                inv.type in ('out_invoice', 'out_refund')
                AND inv.state in ('paid', 'open', 'draft', 'proforma2', 'grouped_proforma')
                AND inv.date_invoice BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'