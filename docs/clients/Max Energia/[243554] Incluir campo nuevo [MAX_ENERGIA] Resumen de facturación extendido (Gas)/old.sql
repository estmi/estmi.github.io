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
            
            CASE
                WHEN inv.residual > 0 THEN null
                ELSE (acc.date)
            END as "F. Pago Factura",

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
            inv.residual as "Residual",
            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN fact.consumo_kwh * -1
                ELSE fact.consumo_kwh
             END as "Consumo facturado (kWh)",

            COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
            FROM giscegas_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'fijo'
            AND linia.name = 'P1'
          ), 0) as "Preu Fixe",

           COALESCE( (SELECT round(SUM(linia.price_subtotal)/CASE WHEN SUM(linia.quantity) = 0 THEN 1 ELSE SUM(linia.quantity) END,6)
            FROM giscegas_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'variable'
            AND linia.name = 'P1'
          ), 0) as "Preu Variable",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT SUM(linia.quantity * -1)
		    FROM giscegas_facturacio_factura_linia flinia
		    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
		    WHERE linia.invoice_id = inv.id
		    AND flinia.tipus = 'fijo'
		    AND linia.name = 'P1'
		    ), 0)
                ELSE COALESCE( (SELECT SUM(linia.quantity)
		     FROM giscegas_facturacio_factura_linia flinia
		     JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
		     WHERE linia.invoice_id = inv.id
		     AND flinia.tipus = 'fijo'
		     AND linia.name = 'P1'
		     ), 0)
            END as "Fijo (kWh)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT SUM(linia.quantity * -1)
		    FROM giscegas_facturacio_factura_linia flinia
		    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
		    WHERE linia.invoice_id = inv.id
		    AND flinia.tipus = 'variable'
		    AND linia.name = 'P1'
		    ), 0)
                ELSE COALESCE( (SELECT SUM(linia.quantity)
		     FROM giscegas_facturacio_factura_linia flinia
		     JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
		     WHERE linia.invoice_id = inv.id
		     AND flinia.tipus = 'variable'
		     AND linia.name = 'P1'
		     ), 0)
            END as "Variable (kWh)",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscegas_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'fijo'
            AND linia.name = 'P1'
          ), 0) as "Preu fijo",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'variable'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'variable'
                    ), 0)
            END as "Variable (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'fijo'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'fijo'
                    ), 0)
            END as "Fijo (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'lloguer'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'lloguer'
                    ), 0)
            END as "Lloguer (euros)",

            COALESCE( irectificada.number, ' ') as "Regularizacion",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(base * -1)
                    FROM account_invoice_tax
                    WHERE invoice_id = inv.id AND name like '%hidrocarbur%'
                    GROUP BY invoice_id
                    ), 0)
                ELSE COALESCE( (SELECT sum(base)
                    FROM account_invoice_tax
                    WHERE invoice_id = inv.id AND name like '%hidrocarbur%'
                    GROUP BY invoice_id
                    ), 0)
            END as "Base Impuesto Hidrocarburos",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(amount * -1)
                    FROM account_invoice_tax
                    WHERE invoice_id = inv.id AND name like '%hidrocarbur%'
                    GROUP BY invoice_id
                    ), 0)
                ELSE COALESCE( (SELECT sum(amount)
                    FROM account_invoice_tax
                    WHERE invoice_id = inv.id AND name like '%hidrocarbur%'
                    GROUP BY invoice_id
                    ), 0)
            END as "Impuesto Hidrocarburos",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'lloguer'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'lloguer'
                    ), 0)
            END as "Lloguers (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code like 'CON%'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
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
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'HH01'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'HH01'
                    ), 0)
            END "Altres (Descompte) (euros)",

            COALESCE( mun.name, ' ') as "Municipio",

            COALESCE( (SELECT avg(flect.qdmaximo)
            FROM giscegas_facturacio_lectures flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P1%'
          ), 0) as "Caudal maximo (kW)",

            COALESCE((SELECT avg(lect.lect_anterior)
            FROM giscegas_facturacio_lectures AS lect
            WHERE lect.factura_id = fact.id
            AND lect.name like '%P1%'), 0) AS "Lra. Ant.",

            COALESCE((SELECT avg(lect.lect_actual)
            FROM giscegas_facturacio_lectures AS lect
            WHERE lect.factura_id = fact.id
            AND lect.name like '%P1%'), 0) AS "Lra. Act.",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721' AND linia.name ilike '%variable%'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721' AND linia.name ilike '%variable%'
                    ), 0)
            END as "Otros (Descuento Cargos Variables) (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721' AND linia.name ilike '%fixe%'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721' AND linia.name ilike '%fixe%'
                    ), 0)
            END as "Otros (Descuento Cargos Fijos) (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
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
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id AND linia.discount != 0
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721'
                    ), 0)
                ELSE COALESCE( (SELECT sum(round(linia.price_unit * linia.quantity, 2))
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id AND linia.discount != 0
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'DESC1721'
                    ), 0)
            END as"Otros (Descuento Cargos ya incluidos precio final) (euros)",

            COALESCE( (SELECT count(*)
            FROM giscegas_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721'
            ), 0) as "Otros (Numero de lineas de Cargos)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
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
                    FROM giscegas_facturacio_factura_linia flinia
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
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND linia.name = ('SPA PLUS')
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND linia.name = ('SPA PLUS')
                    ), 0)
            END as "SPA PLUS (euros)",
            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code in ('MTN')
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code in ('MTN')
                    ), 0)
            END as "MTN (euros)",
            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND linia.name = ('SAH')
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND linia.name = ('SAH')
                    ), 0)
            END as "SAH (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'GESP'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'GESP'
                    ), 0)
            END as "GESP (euros)",

            CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
                    AND prod.default_code not like 'CON%'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code not in ('RBS', 'HH01', 'DESC1721', 'SPA', 'SPA PLUS', 'GESP', 'MTN', 'SAH')
                    AND prod.default_code not like 'CON%'
                    ), 0)
            END as "Otros (No clasificados) (euros)",
            pm.name as "Grupo de Pago",

            COALESCE( (SELECT string_agg(linia.name, ',')
            FROM giscegas_facturacio_factura_linia flinia
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
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    JOIN product_product prod ON prod.id = linia.product_id
                    WHERE linia.invoice_id = inv.id
                    AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
                    AND prod.default_code = 'GESP'
                    ))
                ELSE COALESCE( (SELECT string_agg((linia.price_unit * 1)::varchar, ',')
                    FROM giscegas_facturacio_factura_linia flinia
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
            cn.name AS "CNAE",
            pol.consum_anual_oferta_inicial as "Consumo anual oferta inicial",
            inv.residual as "Residual",
           
           CASE
                WHEN inv.type in ('out_refund', 'in_refund') THEN
                    COALESCE( (SELECT sum(linia.price_subtotal * -1)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'fijo_demandado'
                    ), 0)
                ELSE COALESCE( (SELECT sum(linia.price_subtotal)
                    FROM giscegas_facturacio_factura_linia flinia
                    JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
                    JOIN product_uom uom ON uom.id=linia.uos_id
                    WHERE linia.invoice_id = inv.id
                    AND flinia.tipus = 'fijo_demandado'
                    ), 0)
            END as "Importe del exceso (euros)"
        FROM
                giscegas_facturacio_factura fact
                LEFT JOIN account_invoice inv ON inv.id=fact.invoice_id
                LEFT JOIN (
                    SELECT DISTINCT ON (acc2.ref) acc2.*
                    FROM account_move_line acc2
                    WHERE acc2.reconcile_id IS NOT NULL
                    ORDER BY acc2.ref
                ) acc ON (acc.ref = inv.number AND acc.move_id != inv.move_id)
                LEFT JOIN giscegas_polissa_tarifa tarifaatr ON tarifaatr.id=fact.tarifa_acces_id
                LEFT JOIN giscegas_polissa pol ON pol.id=fact.polissa_id
                LEFT JOIN giscegas_cups_ps cups ON cups.id=pol.cups
                LEFT JOIN product_pricelist llista ON llista.id=fact.llista_preu
                LEFT JOIN res_partner part ON part.id=inv.partner_id
                LEFT JOIN res_municipi mun ON mun.id=cups.id_municipi
                LEFT JOIN giscegas_facturacio_factura as rectificada ON rectificada.id=fact.ref
                LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
                LEFT JOIN payment_mode pm ON pm.id=fact.payment_mode_id
                LEFT JOIN payment_mandate AS mandate ON mandate.id = inv.mandate_id
                LEFT JOIN giscemisc_cnae cn ON cn.id = pol.cnae
                LEFT JOIN hr_employee empl ON empl.id = pol.comercial_id
                LEFT JOIN giscegas_polissa_modcontractual modcon ON (
                    pol.id = modcon.polissa_id
                AND
                    (
                        modcon.data_inici <= fact.data_final AND modcon.data_final >= fact.data_final
                    )
                )
        WHERE
                inv.type in ('out_invoice', 'out_refund')
                AND inv.state in ('paid', 'open', 'draft')
                AND inv.date_invoice BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'
