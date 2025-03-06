select 
    auto.cau as cau,
    cups.name as cups,
    'R1-021' as distribuidora_codigo_simel,
    CASE
      WHEN (p.agree_tarifa LIKE '2T') THEN '2.0TD'
      WHEN (p.agree_tarifa LIKE '3T') THEN '3.0TD'
      WHEN (p.agree_tarifa LIKE '6A') THEN '6.1TD'
      ELSE p.agree_tarifa
    END as tarifa,
    'Cádiz' as provincia, 
    p.autoconsumo as tipo_autoconsumo,
    gen.pot_instalada_gen as potencia_generacion,
    potencies_periode as potencias,
    split_part(potencies_periode, ' ', 2) as p1,
    split_part(potencies_periode, ' ', 4) as p2,
    split_part(potencies_periode, ' ', 6) as p3,
    split_part(potencies_periode, ' ', 8) as p4,
    split_part(potencies_periode, ' ', 10) as p5,
    split_part(potencies_periode, ' ', 12) as p6,
    p.potencia as potencia_maxima,
    p.coef_repartiment as coeficiente_reparto
    

from
    giscedata_cups_ps cups
    left join giscedata_polissa p 
        on (p.cups = cups.id)
    left join giscedata_lectures_comptador c
        on (c.polissa = p.id)
    left join res_partner res
        on (res.id = p.titular)
    left join giscedata_facturacio_lot l
        on p.lot_facturacio = l.id
    left join giscedata_autoconsum auto
        on auto.id = cups.autoconsum_id
    left join giscedata_autoconsum_generador gen
        on gen.autoconsum_id = auto.id
    left join giscedata_polissa_modcontractual modcon
        on modcon.id = p.modcontractual_activa



where
    cups.autoconsum_id is not null
    and p.autoconsumo != '00'
    and p.active = 'True'
    and c.data_baixa is null
    and cups.name != 'ES0034121302856568YF1F'  -- CUPS intencionadamente excluido