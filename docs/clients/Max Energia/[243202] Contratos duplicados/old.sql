WITH max_mandate AS (
    SELECT pol.id AS pol_id, MAX(mandate.date) AS max_date
    FROM giscedata_polissa pol
    JOIN payment_mandate mandate ON split_part(mandate.reference, ',', 2)::int = pol.id
    WHERE mandate.date_end is Null
    GROUP BY pol.id
), max_mandate_id AS (
    SELECT MAX(mandate.id) AS max_id
    FROM max_mandate
    JOIN payment_mandate mandate ON split_part(mandate.reference, ',', 2)::int = max_mandate.pol_id
    WHERE mandate.date = max_mandate.max_date
    GROUP BY pol_id
)

SELECT
    comp.name as marca,
    pol.name as codigo_contrato,
    cups.name as cups,
    titular.name as nombre,
    titular.vat as nif,
    cups.direccio as direccion,
    cups_mun.name as municipio,
    COALESCE(address.city, pobl.name) as poblacio,
    state.name as provincia,
    tarifa.name as tarifa,
    representant.name as representant,
    CASE WHEN pol.data_renovacio IS NULL THEN 'No' ELSE 'Si' END as renovado,
    ren.name as "producto de renovación",
    bank.iban,
    address.zip as "codi postal",
    address.email as "Email",
    address.mobile as "Móvil",
    address.phone as "Telefono",
    pol.enviament as "Enviar factura vía",
    fact_address.name as "adressa facturacio",
    fact_mun.name as "municipi facturacio",
    fact_state.name as "provincia facturacio",
    CASE subs.description
        WHEN 'Fuerteventura-Lanzarote' THEN 'Canarias'
        WHEN 'Gran Canaria' THEN 'Canarias'
        WHEN 'Hierro' THEN 'Canarias'
        WHEN 'La Gomera' THEN 'Canarias'
        WHEN 'La Palma' THEN 'Canarias'
        WHEN 'Tenerife' THEN 'Canarias'
        WHEN 'Mallorca-Menorca' THEN 'Baleares'
        WHEN 'Ibiza-Formentera' THEN 'Baleares'
        ELSE subs.description
    END as "Subsistema",
    CASE pol.asegurador
		WHEN 'N' THEN 'No asegurado'
		WHEN 'AP' THEN 'Administración Pública'
		WHEN 'C' THEN 'Cliente'
		WHEN 'X' THEN 'Propia compañia'
		WHEN 'CN' THEN 'Canal'
		WHEN 'CESCE' THEN 'CESCE'
	END as "Asegurador",
    scoring.resultado_scoring as "Resultado Scoring",
    pol.consum_anual_oferta_inicial as "Volumen de consumo",
    pol.consum_anual,
    part.name as "Persona firmante",
    part.vat as "DNI Persona firmante",
    --- Potencies Contractades
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P1'
) as potencia_contratada_p1,
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P2'
) as potencia_contratada_p2,
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P3'
) as potencia_contratada_p3,
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P4'
) as potencia_contratada_p4,
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P5'
) as potencia_contratada_p5,
(
    SELECT SUM(potencia) FROM giscedata_polissa_potencia_contractada_periode pot JOIN giscedata_polissa_tarifa_periodes per ON per.id=pot.periode_id JOIN product_product prod ON prod.id=per.product_id JOIN product_template tmp ON tmp.id=prod.product_tmpl_id WHERE pot.polissa_id = pol.id AND tmp.name = 'P6'
) as potencia_contratada_p6,
-- ------
    pol.autoconsumo,
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
    ) as hijos,
    pol.state as estado_contrato,
   (
        SELECT STRING_AGG(pl.name, ', ') from giscedata_facturacio_services ser
        JOIN product_pricelist pl ON pl.id=ser.llista_preus
               WHERE ser.polissa_id=pol.id and ser.producte != 1703 and ( ser.data_fi is Null or ser.data_fi > CURRENT_DATE)
   ) as serveis_mantenimiento,
   (
        SELECT STRING_AGG(pl.name, ', ') from giscedata_facturacio_services ser
        JOIN product_pricelist pl ON pl.id=ser.llista_preus
        WHERE ser.polissa_id=pol.id and ser.producte = 1703 and ( ser.data_fi is Null or ser.data_fi > CURRENT_DATE)
   ) as serveis_gestion_energia,
    -- serveis contractats,
    grup.name as grupo_de_pago,
    pol.data_alta as fecha_alta_contrato,
    modact.data_final as fecha_fin_contrato,
    pol.data_baixa as fecha_baja_contrato,
    CASE pol.tg
        WHEN '3' THEN 'Si'
    END as telegestionado,
    cnae.name as cnae,
    pricelist.name as producto_contratado,
    mandate.name as referencia_mandato,
    mandate.date as fecha_firma_mandato,
    case 
        when pol.comissio is Null then 'Sin comision' 
        when pol.comissio like '%giscedata.polissa.comissio.maxenergia%' then '[MAXENERGIA] Comisión anual energia y potencia'
        when pol.comissio like '%giscedata.polissa.comissio.globalia%' then '[GLOBALIA] Comisión anual'
        when pol.comissio like '%giscedata.polissa.comissio.gl%' then '[EB] Comisión anual'
        when pol.comissio like '%carteri%' then 'Carterizada'
        else 'Sin comision'
    end as tipo_comision,
    CASE titular.tipo_cliente_cesce
        WHEN 'N' THEN 'No Clasificados'
        WHEN 'A' THEN 'Asegurados Anónimos'
        WHEN 'C' THEN 'Classificado'
    END as "tipo_cliente_cesce",
    CASE titular.estado_cesce
        WHEN '66' THEN 'En vigor'
        WHEN '2' THEN 'Anulada'
        WHEN '8' THEN 'Anulada-Mantenimiento'
    END as "estado_cesce",
    titular.riesgo_concedido_cesce as riesgo_concedido,
    (
        SELECT base_price from product_pricelist_item ppi
        left join product_pricelist_version ppv on ppi.price_version_id = ppv.id
        where ppi.product_id in (1707,1708,1709) 
        and ppi.name like ('%' || SUBSTRING(tarifa.name, 1, 1) || '%')
        and ppv.pricelist_id = pricelist.id
        and ppv.date_end is Null
    ) as fee_baleares,
    GREATEST(pol.fee_p1, pol.fee_p2, pol.fee_p3, pol.fee_p4, pol.fee_p5, pol.fee_p6) as fee_max,
    pol.fee2 as fee2,
    pol.margen_potencia as margen_potencia
FROM
    giscedata_polissa pol
    LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
    LEFT JOIN res_partner_bank bank ON pol.bank=bank.id
    LEFT JOIN res_partner titular ON titular.id=pol.titular
    LEFT JOIN res_partner_address address ON pol.direccio_notificacio = address.id
    LEFT JOIN res_municipi cups_mun ON cups.id_municipi= cups_mun.id
    LEFT JOIN giscedata_polissa_tarifa tarifa ON tarifa.id=pol.tarifa
    LEFT JOIN payment_mode grup ON grup.id = pol.payment_mode_id
    LEFT JOIN res_company comp ON comp.id = pol.company_id
    LEFT JOIN res_country_state state ON state.id = cups_mun.state
    LEFT JOIN res_poblacio pobl ON cups.id_poblacio =  pobl.id
    LEFT JOIN giscemisc_cnae cnae ON cnae.id = pol.cnae
    LEFT JOIN res_partner representant ON pol.representante_id=representant.id
    LEFT JOIN res_partner_address fact_address ON pol.direccio_pagament=fact_address.id
    LEFT JOIN res_municipi fact_mun ON fact_address.id_municipi=fact_mun.id
    LEFT JOIN res_country_state fact_state ON fact_state.id=fact_mun.state
    LEFT JOIN res_subsistemas_electricos subs ON cups_mun.subsistema_id = subs.id
    LEFT JOIN product_pricelist pricelist ON pricelist.id = pol.llista_preu
    LEFT JOIN product_pricelist ren ON ren.id = pol.next_pricelist_id
    LEFT JOIN payment_mandate mandate ON (split_part(mandate.reference, ',', 2)::int = pol.id) AND mandate.id in (select * from max_mandate_id)
    LEFT JOIN giscedata_crm_lead lead ON lead.contract_number = pol.name
    LEFT JOIN res_partner part ON part.id=pol.firmant_id
    LEFT JOIN giscedata_polissa_modcontractual modact on modact.id = pol.modcontractual_activa
    LEFT JOIN (
        SELECT DISTINCT ON(crm_lead_id) crm_lead_id, resultado_scoring
        FROM giscedata_crm_lead_scoring_log
        ORDER BY crm_lead_id, datetime desc
    ) scoring ON scoring.crm_lead_id = lead.id
WHERE
    (comp.id in $marca)