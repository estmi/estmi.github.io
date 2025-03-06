SELECT 
    pol.id AS 'Id Polissa'
    ,pol.name AS 'N Polissa'
    ,cups.name AS 'CUPS'
    ,pol.data_baixa AS 'Data Baixa'
    ,swp.name AS 'Proces'
FROM
    giscedata_polissa pol
LEFT JOIN
    giscedata_polissa pol2
ON
    pol.cups = pol2.cups and pol2.state = 'activa'
LEFT JOIN
    giscedata_cups_ps cups
ON
    cups.id = pol.cups
LEFT JOIN
    giscedata_switching sw
ON 
    sw.cups_polissa_id = pol.id
LEFT JOIN
    giscedata_switching_proces swp
ON 
    swp.id = sw.proces_id
LEFT JOIN 
    giscedata_switching_step_info swsi
ON 
    swsi.sw_id = sw.id
LEFT JOIN giscedata_switching_step sws
ON 
    sws.id = swsi.step_id
WHERE
    pol.state = 'baixa'
    AND pol.autoconsumo = '00'
    AND pol2.ID IS NULL
    AND pol.data_baixa < date '2023-09-01'
    AND (swp.name = 'C1' or swp.name = 'C2')
    AND sws.name = '06'
ORDER BY
    pol.data_baixa;