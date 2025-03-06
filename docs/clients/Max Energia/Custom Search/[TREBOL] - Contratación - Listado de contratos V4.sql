SELECT 
    pol.name as id,
    titular.name as nombre,
    titular.vat as nif,
    cups.name as cups,
    tarifa.name as tarifa_regulada,
    pol.state as estado_contrato,
    swp.name as proceso,
    sws.name as paso,
    sw.create_date as fecha_proceso,
    pol.data_alta as fecha_inicio_contrato,
    modactiva.data_final as fecha_fin_contrato,
 
-- ------
-- Potencies Contractades
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P1' 
) as potencia_contratada_p1,

(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P2' 
) as potencia_contratada_p2,

(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P3' 
) as potencia_contratada_p3,

(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P4' 
) as potencia_contratada_p4,

(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P5' 
) as potencia_contratada_p5,

(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot 
    JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id 
    JOIN product_product prod ON prod.id=per.product_id 
    JOIN product_template tmp ON tmp.id=prod.product_tmpl_id 
    WHERE pot.polissa_id = pol.id AND tmp.name = 'P6' 
) as potencia_contratada_p6,

-- ------
-- Estimacio Consum anual

(
    SELECT SUM(energia_kwh) FROM giscedata_facturacio_factura fact JOIN account_invoice inv ON inv.id=fact.invoice_id WHERE polissa_id=pol.id AND inv.type='out_invoice' AND fact.tipo_factura='01' AND fact.data_final > date_trunc('month', CURRENT_DATE) - INTERVAL '1 year'
) as activa_kw_consum_facturat_ultims_12_mesos,
(
    SELECT count(*) FROM giscedata_facturacio_factura fact JOIN account_invoice inv ON inv.id=fact.invoice_id WHERE polissa_id=pol.id AND inv.type='out_invoice' AND fact.tipo_factura='01' AND fact.data_final > date_trunc('month', CURRENT_DATE) - INTERVAL '1 year'
) as numero_factures_utilitzades,

-- ------

    distri.name as distribuidora,
    tensio.name as tension,
    pol.agree_tipus as tipo_telegestion,
    subsistema.description as subsistema,


-- Data activacio prevista pas 02
(
    COALESCE(
        COALESCE(
            (SELECT c102.data_activacio FROM giscedata_switching_c1_02 c102 JOIN giscedata_switching_step_header c102h ON c102h.id=c102.header_id WHERE c102h.sw_id = sw_alta.id LIMIT 1),
            (SELECT c202.data_activacio FROM giscedata_switching_c2_02 c202 JOIN giscedata_switching_step_header c202h ON c202h.id=c202.header_id WHERE c202h.sw_id = sw_alta.id LIMIT 1)
         ),
        (SELECT a302.data_activacio FROM giscedata_switching_a3_02 a302 JOIN giscedata_switching_step_header a302h ON a302h.id=a302.header_id WHERE a302h.sw_id = sw_alta.id LIMIT 1)
     )
)as fecha_activacion_prevista,
-- ------
-- Data baixa prevista pas 11
(
    COALESCE(
            (SELECT c111.data_activacio FROM giscedata_switching_c1_11 c111 JOIN giscedata_switching_step_header c111h ON c111h.id=c111.header_id WHERE c111h.sw_id = sw_baixa.id),
            (SELECT c211.data_activacio FROM giscedata_switching_c2_11 c211 JOIN giscedata_switching_step_header c211h ON c211h.id=c211.header_id WHERE c211h.sw_id = sw_baixa.id)
     )
)as fecha_baja_prevista,
-- ------

    cups.direccio as direccio,
    COALESCE(noti.mobile, noti.phone) as telefono_envio,
    llista_preus.name as nombre_tarifa,


-- ------
-- Preus Energia
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P1'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p1,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P2'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p2,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P3'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p3,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P4'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p4,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P5'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p5,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P6'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='te' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preu_energia_p6,

-- ------
-- Preus Potencia
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P1'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p1,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P2'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p2,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P3'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p3,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P4'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p4,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P5'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p5,
(
    SELECT item.base_price
    FROM product_pricelist_item item
    JOIN product_product prod ON item.product_id=prod.id
    JOIN product_template tmp ON prod.product_tmpl_id=tmp.id
    JOIN product_pricelist_version versio ON versio.id=item.price_version_id
    JOIN product_pricelist pricelist ON pricelist.id=versio.pricelist_id
    WHERE
        pricelist.id=llista_preus.id
        AND tmp.name = 'P6'
        AND prod.id in (select product_id from giscedata_polissa_tarifa_periodes where tarifa=pol.tarifa and tipus='tp' )
    ORDER BY 
        versio.date_start DESC
    LIMIT 1
) as preus_potencia_p6,

-- ------

    noti.email as email_envio,
    (CASE WHEN sw.additional_info like '%Rebuig%' or sw.additional_info like '%Rechazo%' THEN sw.additional_info ELSE '' END) as motivo_rechazo,
    COALESCE(ccaa.name, rcs.name) as CCAA_provincia,
    pol.autoconsumo as tipus_autoconsum,
    pol.consum_anual as consumo_anual,
    cups.dp as codipostal,
    pol.margen_potencia as "FEE potencia",
   (select data_inici from giscedata_polissa_modcontractual where polissa_id = pol.id and state = 'pendent') as fecha_renovacion,
    (select data_final from giscedata_polissa_modcontractual where polissa_id = pol.id and state = 'pendent') as fecha_final_tras_renovacion,
   
COALESCE(
	(SELECT pare.name from hr_colaborador_giscedata_polissa colpol
	JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
	JOIN hr_colaborador pare ON pare.id=fill.parent_id
	WHERE colpol.polissa_id = pol.id
	LIMIT 1),
	(SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscedata_polissa colpol
	JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
	WHERE colpol.polissa_id = pol.id)
) as "Colaboradores Padre",
    (
        SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscedata_polissa colpol 
        JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
        WHERE colpol.polissa_id = pol.id
    ) as hijos

    


FROM
    giscedata_polissa pol
    LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
    LEFT JOIN res_partner titular ON titular.id=pol.titular
    LEFT JOIN res_partner distri ON distri.id=pol.distribuidora
    LEFT JOIN product_pricelist llista_preus ON llista_preus.id=pol.llista_preu
    LEFT JOIN giscedata_polissa_tarifa tarifa ON tarifa.id=pol.tarifa
    LEFT JOIN giscedata_polissa_modcontractual modactiva ON modactiva.id=pol.modcontractual_activa
    LEFT JOIN giscedata_switching sw ON sw.id=(select max(sw2.id) from giscedata_switching sw2 where sw2.cups_polissa_id = pol.id)
    LEFT JOIN giscedata_switching_proces swp ON sw.proces_id=swp.id
    LEFT JOIN giscedata_switching_step sws ON sw.step_id=sws.id
    LEFT JOIN giscedata_tensions_tensio tensio ON tensio.id=pol.tensio_normalitzada
    LEFT JOIN res_municipi mun ON cups.id_municipi=mun.id
    LEFT JOIN res_country_state rcs ON rcs.id=mun.state 
    LEFT JOIN res_comunitat_autonoma ccaa ON ccaa.id=rcs.comunitat_autonoma
    LEFT JOIN res_subsistemas_electricos subsistema ON subsistema.id=mun.subsistema_id
    LEFT JOIN res_partner_address noti ON noti.id=pol.direccio_notificacio
    LEFT JOIN giscedata_switching sw_alta ON sw_alta.id=(
        select max(sw3.id) 
        from giscedata_switching sw3 
        join giscedata_switching_proces p3 ON p3.id=sw3.proces_id
        join giscedata_switching_step s3 ON s3.id=sw3.step_id
        where sw3.cups_polissa_id = pol.id 
        and p3.name in ('A3', 'C1', 'C2')
        and s3.name not in ('11', '06')
    )
    LEFT JOIN giscedata_switching sw_baixa ON sw_baixa.id=(
        select max(sw4.id) 
        from giscedata_switching sw4 
        join giscedata_switching_proces p4 ON p4.id=sw4.proces_id
        join giscedata_switching_step s4 ON s4.id=sw4.step_id
        where sw4.cups_polissa_id = pol.id 
        and p4.name in ('A3', 'C1', 'C2')
        and s4.name in ('11', '06')
    )
WHERE
    pol.state in ('esborrany', 'activa', 'baixa', 'baixa2', 'modcontractual','pendent', 'cancelada', 'validar','contracte','tall')
ORDER BY pol.id desc
