query_cups_baixa_sense_retorn = """SELECT 
    pol.name
    ,pol.id AS polissa_id
    ,cups.name
    ,pol.data_baixa
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
WHERE
    pol.state = 'baixa'
    AND pol.autoconsumo = '00'
    AND pol2.ID IS NULL
    AND pol.data_baixa < date '2023-09-01'
ORDER BY
    pol.cups;"""

cursor.execute(query_cups_baixa_sense_retorn)
data = cursor.dictfetchall()

for dades in data:
