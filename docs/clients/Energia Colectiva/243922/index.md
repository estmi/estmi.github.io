# [243922] Circular 2/2005 ENERGÍA COLECTIVA

## SQL filtrat per periode T3 i R1-001 i COD_TAR 19

```sql
SELECT
  aggregation.ANIO_ENVIO,
  aggregation.TRIMESTRE_ENVIO,
  aggregation.COD_COM,
  aggregation.COD_DIS,
  aggregation.COD_TPM,
  aggregation.MODO_FACTURACION,
  (
    SELECT
      COUNT(DISTINCT md.polissa_id)
    FROM
      giscedata_polissa_modcontractual md
      INNER JOIN (
        SELECT
          CASE
            WHEN t.name = '2.0A' THEN '01'
            WHEN t.name = '2.0DHA' THEN '02'
            WHEN t.name = '3.0A' THEN '03'
            WHEN t.name = '3.0A LB' THEN '03'
            WHEN t.name = '3.1A' THEN '04'
            WHEN t.name = '3.1A LB' THEN '04'
            WHEN t.name = '6.1' THEN '05'
            WHEN t.name = '6.1A' THEN '05'
            WHEN t.name = '6.1B' THEN '17'
            WHEN t.name = '6.2' THEN '06'
            WHEN t.name = '6.3' THEN '07'
            WHEN t.name = '6.4' THEN '08'
            WHEN t.name = '6.5' THEN '09'
            WHEN t.name = '2.1A' THEN '10'
            WHEN t.name = '2.1DHA' THEN '11'
            WHEN t.name = '2.0DHS' THEN '12'
            WHEN t.name = '2.1DHS' THEN '13'
            WHEN t.name = '2.0TD' THEN '18'
            WHEN t.name = '3.0TD' THEN '19'
            WHEN t.name = '6.1TD' THEN '20'
            WHEN t.name = '6.2TD' THEN '21'
            WHEN t.name = '6.3TD' THEN '22'
            WHEN t.name = '6.4TD' THEN '23'
            WHEN t.name = '3.0TDVE' THEN '24'
            WHEN t.name = '6.1TDVE' THEN '25'
          END AS codi_tarifa,
          t.id AS tarifa_id
        FROM giscedata_polissa_tarifa t
      ) tarifa ON md.tarifa = tarifa.tarifa_id
      LEFT JOIN giscedata_polissa pol ON md.polissa_id = pol.id
      LEFT JOIN res_partner comer ON pol.comercialitzadora = comer.id
      LEFT JOIN res_partner distri ON md.distribuidora = distri.id
      JOIN giscedata_cups_ps cups ON md.cups = cups.id
      JOIN res_municipi mun ON cups.id_municipi = mun.id
      LEFT JOIN res_country_state cs ON mun.state = cs.id
    WHERE '2024-09-30' BETWEEN md.data_inici AND md.data_final
      AND md.agree_tipus = aggregation.COD_TPM
      AND (
        distri.ref2 IS NULL OR distri.ref2 = aggregation.COD_DIS
      )
      AND comer.ref2 = aggregation.COD_COM
      AND RPAD(cs.code::text, 5, '0') = aggregation.COD_PRV
      AND tarifa.codi_tarifa = aggregation.COD_TIPO_TAR_ACCESO
  ) AS num_sum,
  aggregation.COD_PRV,
  aggregation.COD_TIPO_TAR_ACCESO,
  CASE
    WHEN aggregation.ENERGIA = 0 THEN 0
    ELSE round(aggregation.PRE_MED_TAR / ENERGIA, 3)
  END,
  CASE
    WHEN aggregation.ENERGIA = 0 THEN 0
    ELSE round(aggregation.PRE_MED_SUM / ENERGIA, 3)
  END,
  aggregation.ENERGIA
FROM (
  SELECT
    TO_CHAR(DATE('2024-09-30'),'YYYY') AS ANIO_ENVIO,
    'T3' AS TRIMESTRE_ENVIO,
    comer.ref2 AS COD_COM,
    COALESCE(distri.ref2, distri.name) AS COD_DIS,
    polissa.agree_tipus AS COD_TPM,
    1 AS MODO_FACTURACION,
    RPAD(cs.code::text, 5, '0') AS COD_PRV,
    (
      SELECT CASE
        WHEN t.name = '2.0A' THEN '01'
        WHEN t.name = '2.0DHA' THEN '02'
        WHEN t.name = '3.0A' THEN '03'
        WHEN t.name = '3.0A LB' THEN '03'
        WHEN t.name = '3.1A' THEN '04'
        WHEN t.name = '3.1A LB' THEN '04'
        WHEN t.name = '6.1' THEN '05'
        WHEN t.name = '6.1A' THEN '05'
        WHEN t.name = '6.1B' THEN '17'
        WHEN t.name = '6.2' THEN '06'
        WHEN t.name = '6.3' THEN '07'
        WHEN t.name = '6.4' THEN '08'
        WHEN t.name = '6.5' THEN '09'
        WHEN t.name = '2.1A' THEN '10'
        WHEN t.name = '2.1DHA' THEN '11'
        WHEN t.name = '2.0DHS' THEN '12'
        WHEN t.name = '2.1DHS' THEN '13'
        WHEN t.name = '2.0TD' THEN '18'
        WHEN t.name = '3.0TD' THEN '19'
        WHEN t.name = '6.1TD' THEN '20'
        WHEN t.name = '6.2TD' THEN '21'
        WHEN t.name = '6.3TD' THEN '22'
        WHEN t.name = '6.4TD' THEN '23'
        WHEN t.name = '3.0TDVE' THEN '24'
        WHEN t.name = '6.1TDVE' THEN '25'
      END
    ) AS COD_TIPO_TAR_ACCESO,
    COALESCE(SUM(flin.atrprice_subtotal * CASE WHEN inv.type = 'out_refund' THEN -1 ELSE 1 END * 100), 0) AS PRE_MED_TAR,

    COALESCE(SUM((line.price_subtotal - flin.atrprice_subtotal)* CASE WHEN inv.type = 'out_refund' THEN -1 ELSE 1 END * 100), 0) AS PRE_MED_SUM,

    round(sum(COALESCE(
      CASE WHEN flin.tipus = 'energia' AND line.product_id not in (select id from product_product where default_code in ('RMAG', 'CB'))
      THEN (CASE WHEN inv.type = 'out_refund' THEN -line.quantity  ELSE line.quantity END)
      ELSE 0 END, 0
    )), 0)::int AS ENERGIA
  FROM
    giscedata_facturacio_factura fact
    JOIN giscedata_facturacio_factura_linia flin ON fact.id = flin.factura_id
    JOIN account_invoice inv ON inv.id = fact.invoice_id
    JOIN account_invoice_line line ON flin.invoice_line_id = line.id
    JOIN giscedata_polissa polissa ON polissa.id = fact.polissa_id
    JOIN giscedata_polissa_tarifa t ON t.id = polissa.tarifa
    LEFT JOIN res_partner comer ON polissa.comercialitzadora = comer.id
    LEFT JOIN res_partner distri ON polissa.distribuidora = distri.id
    JOIN giscedata_cups_ps cups ON polissa.cups = cups.id
    JOIN res_municipi mun ON cups.id_municipi = mun.id
    LEFT JOIN res_country_state cs ON mun.state = cs.id
  WHERE
    inv.date_invoice BETWEEN '2023-10-01' AND '2024-09-30'
    AND flin.tipus IN ('energia', 'potencia', 'reactiva', 'exces_potencia')
    AND inv.type IN ('out_invoice', 'out_refund')
    AND inv.state NOT IN ('draft', 'cancel', 'proforma')
    AND fact.energia_kwh != 0
    AND t.name = '3.0TD'
    AND COALESCE(distri.ref2, distri.name) = 'R1-001'
  GROUP BY
    ANIO_ENVIO, TRIMESTRE_ENVIO, COD_COM, COD_DIS, COD_TPM, MODO_FACTURACION, COD_PRV, COD_TIPO_TAR_ACCESO
  ORDER BY
    COD_PRV
) AS aggregation
WHERE
  aggregation.ENERGIA > 0;
```

| anio_envio | trimestre_envio | cod_com | cod_dis | cod_tpm | modo_facturacion | num_sum | cod_prv | cod_tipo_tar_acceso | round | round  | energia |
|------------|-----------------|---------|---------|---------|------------------|---------|---------|---------------------|-------|--------|---------|
| 2024       | T3              | R2-542  | R1-001  | 04      |                1 |       1 | 28000   | 19                  | 1.692 | 13.940 |   53117 |


## Polissa afectada: 318187 (id: 422474)

- Factures affectades (15): 13812314, 13473559, 13028953, 12628095, 12196013, 11948615, 11623519, 11260499, 10975023, 10668632, 10406839, 10279401, 10060830, 10060829, 9792926

### Dades linies factures

#### Tots els decimals
```sql
SELECT
    sum(line.quantity * line.price_unit),
    sum(flin.atrprice_subtotal),
    sum((line.quantity * line.price_unit) - flin.atrprice_subtotal) 
FROM giscedata_facturacio_factura fact
JOIN giscedata_facturacio_factura_linia flin ON fact.id = flin.factura_id
JOIN account_invoice inv ON inv.id = fact.invoice_id
JOIN account_invoice_line line ON flin.invoice_line_id = line.id
WHERE fact.id in (13812314, 13473559, 13028953, 12628095, 12196013, 11948615, 11623519, 11260499, 10975023, 10668632, 10406839, 10279401, 10060830, 10060829, 9792926);
```

| total linies | total peatges | total sense peatges |
|----------------|--------|----------------|
| 8246.934574020 | 986.13 | 7260.804574020 |

:::info Calcul
Energia: 53117
Total sense peatges: 7260.804574020
Final: 726080.4574020 / 53117 = 13.669455304
:::

#### Base ja arrodonida a 2

```sql
SELECT
    sum(line.price_subtotal),
    sum(flin.atrprice_subtotal),
    sum((line.price_subtotal - flin.atrprice_subtotal))
FROM giscedata_facturacio_factura fact
JOIN giscedata_facturacio_factura_linia flin ON fact.id = flin.factura_id
JOIN account_invoice inv ON inv.id = fact.invoice_id
JOIN account_invoice_line line ON flin.invoice_line_id = line.id
WHERE fact.id in (13812314, 13473559, 13028953, 12628095, 12196013, 11948615, 11623519, 11260499, 10975023, 10668632, 10406839, 10279401, 10060830, 10060829, 9792926);
```

| total linies | total peatges | total sense peatges |
|----------------|--------|----------------|
| 8246.95 | 986.13 | 7260.82|

:::info Calcul
Energia: 53117
Total sense peatges: 7260.82
Final: 7260.82 / 53117 = 13.669455304
:::
