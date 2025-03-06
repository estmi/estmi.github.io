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
        
            CASE WHEN inv.type IN ('out_refund', 'in_refund') THEN inv.amount_untaxed*-1 ELSE inv.amount_untaxed END as "Base imponible",
            CASE WHEN inv.type IN ('out_refund', 'in_refund') THEN inv.amount_tax*-1 ELSE inv.amount_tax END as "Impuestos",
            CASE WHEN inv.type IN ('out_refund', 'in_refund') THEN inv.amount_total*-1 ELSE inv.amount_total END as "Total",
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
            
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P1'
            ), 0) as "Energia P1 (kW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P2'
            ), 0) as "Energia P2 (kW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P3'
            ), 0) as "Energia P3 (kW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P4'
            ), 0) as "Energia P4 (kW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P5'
            ), 0) as "Energia P5 (kW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P6'
            ), 0) as "Energia P6 (kW)",
        
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
        
            COALESCE( (SELECT  AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0) as "Potencia P1 (KW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0) as "Potencia P2 (KW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0) as "Potencia P3 (KW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0) as "Potencia P4 (KW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0) as "Potencia P5 (KW)",
        
            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0) as "Potencia P6 (KW)",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('energia', 'subtotal_xml_ene')
            ), 0) as "Activa (euros)",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('potencia', 'subtotal_xml_pow')
            ), 0) as "Potencia (euros)",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('exces_potencia', 'subtotal_xml_exc')
            ), 0) as "Excesos Potencia (euros)",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('reactiva', 'subtotal_xml_rea')
            ), 0) as "Reactiva (euros)",

            COALESCE( irectificada.number, ' ') as "Regularizacion",

            COALESCE( (SELECT sum(base)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0) as "Base Impuesto Electrico",
        
            COALESCE( (SELECT sum(amount)
            FROM account_invoice_tax 
            WHERE invoice_id = inv.id AND name like '%electric%'
            GROUP BY invoice_id
            ), 0) as "Impuesto Electrico",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('lloguer', 'subtotal_xml_ren')
            ), 0) as "Lloguers (euros)",
            
            COALESCE( (SELECT sum(linia.price_unit)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus in ('lloguer')
            ), 0) as "Precio Alquiler",
        
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code != 'HH01'
            ), 0) as "Altres (Derechos Dist.) (euros)",

            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'HH01'
            ), 0) as "Altres (Descompte T.Rellotge) (euros)",
        
            COALESCE( mun.name, ' ') as "Municipio",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P1%'
            ), 0) as "Reactiva P1 (kVar)",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P2%'
            ), 0) as "Reactiva P2 (kVar)",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P3%'
            ), 0) as "Reactiva P3 (kVar)",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P4%'
            ), 0) as "Reactiva P4 (kVar)",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P5%'
            ), 0) as "Reactiva P5 (kVar)",
        
            COALESCE( (SELECT AVG(flect.lect_actual)
            FROM giscedata_facturacio_lectures_energia flect
            WHERE flect.factura_id = fact.id
            AND flect.tipus = 'reactiva'
            AND flect.name like '%P6%'
            ), 0) as "Reactiva P6 (kVar)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P1%'
            ), 0) as "Maximetre P1 (kW)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P2%'
            ), 0) as "Maximetre P2 (kW)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P3%'
            ), 0) as "Maximetre P3 (kW)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P4%'
            ), 0) as "Maximetre P4 (kW)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P5%'
            ), 0) as "Maximetre P5 (kW)",
        
            COALESCE( (SELECT AVG(flect.pot_maximetre)
            FROM giscedata_facturacio_lectures_potencia flect
            WHERE flect.factura_id = fact.id
            AND flect.name like '%P6%'
            ), 0) as "Maximetre P6 (kW)",
            f1.create_date as fecha_carga_f1,
            f1.fecha_factura as fecha_factura_original,
            comercial.name as Comercial

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
                LEFT JOIN giscedata_facturacio_importacio_linia_factura f1rel ON f1rel.factura_id=fact.id
                LEFT JOIN giscedata_facturacio_importacio_linia f1 ON f1rel.linia_id=f1.id
                LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
                LEFT JOIN hr_employee comercial ON comercial.id = pol.comercial_id
        WHERE
                inv.type in ('in_invoice', 'in_refund')
                AND inv.state in ('paid', 'open', 'draft')
                AND fact.data_inici <= '$fecha_consumo_hasta' AND fact.data_final >= '$fecha_consumo_desde'