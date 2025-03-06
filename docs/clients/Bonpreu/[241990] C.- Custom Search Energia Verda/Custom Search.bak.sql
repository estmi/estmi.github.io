SELECT 
    pol.id as "ID Polissa",
    tarifaatr.name as "Tarifa",
    SUM(energia_kwh) as "Volum de kW facturats amb energia Verda",
    CONCAT(pricelist.name, ' - ', pricelist.nom_comercial) as "Detall de volum de kW facturats"
FROM
    giscedata_facturacio_factura fact
    LEFT JOIN account_invoice inv ON inv.id = fact.invoice_id
    LEFT JOIN giscedata_polissa_tarifa tarifaatr ON tarifaatr.id = fact.tarifa_acces_id
    LEFT JOIN product_pricelist pricelist ON pricelist.id = fact.llista_preu
    LEFT JOIN giscedata_polissa pol ON pol.id = fact.polissa_id
WHERE
    inv.type in ('out_invoice', 'out_refund')
    AND inv.state in ('paid', 'open', 'draft')
    AND (
        tarifaatr.name = '2.0TD'
        OR (tarifaatr.name != '2.0TD' AND pricelist.name LIKE '% V%')
    )
    AND pol.data_alta BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'
    AND NOT (pricelist.id in ($llistes_de_preus_excloses) 
                OR pricelist.id in (10, -- Pla Autoconsum
                                    30, -- Pla Empreses Indexat
                                    49, -- Pla Autoconsum 2021
                                    56, -- Pla indexat K08
                                    95, -- Pla Indexat K2 futurs
                                    172, -- Pla Dinàmic K5 D4
                                    227, -- Pla Indexat K5 autoconsum
                                    228, -- Pla Indexat K3 AT venda excedents
                                    288, -- 2.0TD Indexat k3
                                    305, -- Pla Dinàmic
                                    348, -- Pla Dinàmic K2 D4 E indexat
                                    359, -- Pla Eficient 3.0 MP74 ME22 1A
                                    360, -- Pla Eficient 6.1 MP75 ME18 1A
                                    363, -- Pla Eficient 3.0 MP70 ME10 1A
                                    374, -- Pla Eficient 3.0 MP65 ME2 1A Exc Fix
                                    378, -- Pla Eficient 3.0 MP75 ME10 1A
                                    379, -- Pla Fix 3.0 MP52 ME0 1A
                                    380, -- Pla Eficient 3.0 MP70 ME5 1A
                                    382, -- Pla Eficient 6.1 MP70 ME5 1A
                                    385, -- Pla Dinàmic K6 D4
                                    387, -- Pla Dinàmic K4 D4
                                    390, -- Pla Dinàmic K2 D4
                                    392, -- Pla Dinàmic K1 D4
                                    393, -- Pla Eficient 6.1 MP64 ME0 1A
                                    397, -- Pla Eficient 3.0 MP52 ME0 1A
                                    401, -- Pla Eficient 6.1 MP64,7 ME0 1A
                                    402, -- Pla Eficient 3.0 MP65 ME2 1A Exc Indx
                                    405, -- Punts Propis 3.0 BP ME0 1A
                                    406, -- Punts Propis 6.1 BP ME0 1A
                                    408, -- Pla Eficient 6.1 MP64,7 ME0 1A (0.5% descompte)
                                    410, -- Punts Propis 2.0 BP ME0 1A
                                    413 -- Pla Eficient 3.0 MP70 ME0 1A
                                    ))
GROUP BY 
    pol.id, tarifaatr.name, pricelist.name, pricelist.nom_comercial;