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
            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN fact.energia_kwh * -1
                ELSE fact.energia_kwh
           END as "energia_kwh",

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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P1'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P1'
                ), 0)
            END as "Energia P1 Linia (kWh)",
            
-- lectures_energia_ids

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P1%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P1%'), 0)
            END as "Energia P1 Consum (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P2'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P2'
                ), 0)
            END as "Energia P2 (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P2%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P2%'), 0)
            END as "Energia P2 Consum (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P3'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P3'
                ), 0)
            END as "Energia P3 (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P3%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P3%'), 0)
            END as "Energia P3 Consum (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P4'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P4'
                ), 0)
            END as "Energia P4 (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P4%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P4%'), 0)
            END as "Energia P4 Consum (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P5'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P5'
                ), 0)
            END as "Energia P5 (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P5%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P5%'), 0)
            END as "Energia P5 Consum (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P6'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'energia'
                AND linia.name = 'P6'
                ), 0)
            END as "Energia P6 (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P6%'), 0) * -1
            ELSE COALESCE( (select sum(lect.consum) from giscedata_facturacio_lectures_energia lect where lect.factura_id=fact.id and lect.tipus  = 'activa' and lect.name like '%P6%'), 0)
            END as "Energia P6 Consum (kWh)",

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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT  AVG(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0)
            ELSE
            COALESCE( (SELECT  AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0)
            END as "Potencia P1 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT AVG(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0)
            ELSE
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0)
            END as "Potencia P2 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT AVG(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0)
            ELSE
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0)
            END as "Potencia P3 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT AVG(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0)
            ELSE
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0)
            END as "Potencia P4 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0)
            ELSE
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0)
            END as "Potencia P5 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT AVG(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0)
            ELSE
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0) END as "Potencia P6 (KW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            ), 0) END as "Activa (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            ), 0)
            END as "Potencia (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'exces_potencia'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'exces_potencia'
            ), 0)
            END as "Excesos Potencia (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0)
            END as "Reactiva (euros)",

            COALESCE( irectificada.number, ' ') as "Regularizacion",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(base) *-1
            FROM account_invoice_tax
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
            ELSE
            COALESCE( (SELECT sum(base)
            FROM account_invoice_tax
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
            END as "Base Impuesto Electrico",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(amount) *-1
            FROM account_invoice_tax
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
            ELSE
            COALESCE( (SELECT sum(amount)
            FROM account_invoice_tax
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0)
            END as "Impuesto Electrico",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'lloguer'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'lloguer'
            ), 0)
            END as "Lloguers (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id and prod.default_code = 'DSP'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id and prod.default_code = 'DSP'
            ), 0)
            END as "Otros (Despeses gestio) (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code != 'HH01' and prod.default_code != 'DSP'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code != 'HH01' and prod.default_code != 'DSP'
            ), 0)
            END as "Altres (Derechos Dist.) (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'HH01'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'HH01'
            ), 0)
            END as "Altres (Descompte T.Rellotge) (euros)",

            COALESCE( mun.name, ' ') as "Municipio",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) -1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P1'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P1'
            ), 0)
            END as "Reactiva P1 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P2'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P2'
            ), 0)
            END as "Reactiva P2 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P3'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P3'
            ), 0)
            END as "Reactiva P3 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P4'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P4'
            ), 0)
            END as "Reactiva P4 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P5'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P5'
            ), 0)
            END as "Reactiva P5 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT SUM(linia.quantity) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P6'
            ), 0)
            ELSE
            COALESCE( (SELECT SUM(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P6'
            ), 0)
            END as "Reactiva P6 (kVar)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P1%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P1%'
            ), 0)
            END as "Maximetre P1 (kW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P2%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P2%'
            ), 0)
            END as "Maximetre P2 (kW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P3%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P3%'
            ), 0)
            END as "Maximetre P3 (kW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P4%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P4%'
            ), 0)
            END as "Maximetre P4 (kW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P5%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P5%'
            ), 0)
            END as "Maximetre P5 (kW)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT avg(flect.pot_maximetre) *-1
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P6%'
            ), 0)
            ELSE
            COALESCE( (SELECT avg(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P6%'
            ), 0)
            END as "Maximetre P6 (kW)",

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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%potencia%'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%energia%'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
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
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(round(linia.price_unit * linia.quantity, 2)) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id AND linia.discount != 0
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(round(linia.price_unit * linia.quantity, 2))
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id AND linia.discount != 0
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0)
            END as "Otros (Descuento Cargos ya incluidos precio final) (euros)",


            COALESCE( (SELECT count(*)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0) as "Otros (Numero de lineas de Cargos)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0) as "Preu excedent en P1 (euros)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0) as "Preu excedent en P2 (euros)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0) as "Preu excedent en P3 (euros)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0) as "Preu excedent en P4 (euros)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0) as "Preu excedent en P5 (euros)",

            COALESCE( (SELECT avg(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0) as "Preu excedent en P6 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0)
            END as "Import compensat en P1 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0)
            END as "Import compensat en P2 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0)
            END as "Import compensat en P3 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0)
            END as "Import compensat en P4 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0)
            END as "Import compensat en P5 (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
            COALESCE( (SELECT sum(linia.price_subtotal) *-1
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0)
            ELSE
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0)
            END as "Import compensat en P6 (euros)",

           CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P1'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P1'
                ), 0)
            END as "Generació P1 (kWh)",

          CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P2'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P2'
                ), 0)
            END as "Generació P2 (kWh)",

                      CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P3'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P3'
                ), 0)
            END as "Generació P3 (kWh)",
            CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P4'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P4'
                ), 0)
            END as "Generació P4 (kWh)",

          CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P5'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P5'
                ), 0)
            END as "Generació P5 (kWh)",

                      CASE
                WHEN inv.type in ('out_refund', 'in_refund')
            THEN
                COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P6'
                ), 0) * -1
            ELSE COALESCE( (SELECT SUM(linia.quantity)
                FROM giscedata_facturacio_factura_linia flinia
                JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                WHERE linia.invoice_id = inv.id
                AND flinia.tipus = 'generacio'
                AND linia.name = 'P6'
                ), 0)
            END as "Generació P6 (kWh)",

            CASE
            WHEN pol.autoconsumo > '00' THEN 'Si'
            WHEN pol.autoconsumo = '00' THEN 'No'
            END AS "Autoconsum"

        FROM
                giscedata_facturacio_factura fact
                LEFT JOIN account_invoice inv ON inv.id=fact.invoice_id
                LEFT JOIN giscedata_polissa_tarifa tarifaatr ON tarifaatr.id=fact.tarifa_acces_id
                LEFT JOIN giscedata_polissa pol ON pol.id=fact.polissa_id
                LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
                LEFT JOIN product_pricelist llista ON llista.id=fact.llista_preu
                LEFT JOIN res_partner part ON part.id=inv.partner_id
                LEFT JOIN res_municipi mun ON mun.id=cups.id_municipi
                LEFT JOIN giscedata_facturacio_factura as rectificada ON rectificada.id=fact.ref
                LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
        WHERE
                inv.type in ('out_invoice', 'out_refund')
                AND inv.state in ('paid', 'open', 'draft')
                AND inv.date_invoice BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'