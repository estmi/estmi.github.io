# [243662] D-Facturas duplicadas por lote de refacturación

Es detecta que una factura s'ha abonat i rectificat 2 vegades.

## Obtenir factures abonades 2 cops

```sql
select rectifying_id as "rectifying_id (inv)", string_agg(fact.id::varchar,',') as "facturas_que_abonan_la_misma_factura (fact)" from giscedata_facturacio_factura fact left join account_invoice inv on inv.id = fact.invoice_id where rectifying_id is not null and inv.type = 'out_refund' group by inv.rectifying_id having count(*) >=2;
```

| rectifying_id (inv) | facturas_que_abonan_la_misma_factura (fact) |
|---------------------|---------------------------------------------|
|6006911 | 6114399,6114296|
|6007214 | 6114339,6114426|
|6007307 | 6114457,6114368|
|6008532 | 6114371,6114458|
|6013639 | 6114342,6114437|
|6014251 | 6114432,6114343|
|6014318 | 6114385,6114280|
|6014421 | 6114341,6114403|
|6022095 | 6114336,6114429|
|6056052 | 6114377,6114224|
|6056719 | 6114376,6114225|

## Obtenim dades de les factures originals

```sql
select id as "id (fact)", data_inici, data_final, polissa_id from giscedata_facturacio_factura where invoice_id in (6006911,6007214,6007307,6008532,6013639,6014251,6014318,6014421,6022095,6056052,6056719);
```

| id (fact) | data_inici | data_final | polissa_id |
|-----------|------------|------------|------------|
|   5982972 | 2024-11-15 | 2024-12-14 |      37713|
|   5983275 | 2024-11-15 | 2024-12-14 |      31283|
|   5983368 | 2024-11-15 | 2024-12-14 |      10087|
|   5984586 | 2024-11-22 | 2024-12-21 |       1678|
|   5989693 | 2024-11-22 | 2024-12-21 |      24715|
|   5990305 | 2024-11-22 | 2024-12-21 |      35012|
|   5990372 | 2024-11-22 | 2024-12-21 |      19285|
|   5990475 | 2024-11-22 | 2024-12-21 |      24081|
|   5998149 | 2024-11-22 | 2024-12-21 |      43774|
|   6032085 | 2024-12-08 | 2025-01-07 |      33354|
|   6032752 | 2024-12-08 | 2025-01-07 |      37006|

## Obtenir factures relacionades

```sql
select fact.id as "fact id", inv.id as "inv id", inv.rectifying_id from giscedata_facturacio_factura fact left join account_invoice inv on inv.id = fact.invoice_id where fact.polissa_id = 37713 and fact.data_inici >= '2024-11-15' and fact.data_final <= '2024-12-14';
```

| fact id | inv id  | rectifying_id| 
|---------|---------|--------------|
| 5982972 | 6006911 |              |
| 6114296 | 6141317 |       6006911|
| 6114327 | 6141386 |              |
| 6114348 | 6141422 |              |
| 6114399 | 6141452 |       6006911|
| 6114412 | 6141520 |              |
| 6114447 | 6141559 |              |

## Obtenir resum

```sql
select 
    pol.name as "Poliza"
    , fact.id as "ID factura (fact)"
    , inv.id as "ID factura (inv)"
    , inv.number as "N fact"
    , inv.rectifying_id as "Factura rectificada"
    , fact.data_inici as "Fecha inicio"
    , fact.data_final as "Fecha final"
    , part.name as "Receptor Factura"
from giscedata_facturacio_factura fact
left join account_invoice inv
    on inv.id = fact.invoice_id 
right join (
    select id as "id (fact)", data_inici, data_final, polissa_id
    from giscedata_facturacio_factura 
    where invoice_id in (
        select 
            rectifying_id as "rectifying_id (inv)" 
        from giscedata_facturacio_factura fact 
        left join account_invoice inv 
            on inv.id = fact.invoice_id 
        where rectifying_id is not null 
            and inv.type = 'out_refund' 
        group by inv.rectifying_id 
        having count(*) >= 2
        )
    ) as inner2 
        on inner2.polissa_id = fact.polissa_id 
        and fact.data_inici >= inner2.data_inici 
        and fact.data_final <= inner2.data_final
left join giscedata_polissa pol 
    on pol.id = fact.polissa_id
left join res_partner part 
    on part.id = inv.partner_id;
```

|  Poliza   | ID factura (fact) | ID factura (inv) |    N fact     | Factura rectificada | Fecha inicio | Fecha final |                 Receptor Factura                  |
|---|---|------------------|---------------|---------------------|--------------|-------------|---------------------------------------------------|
| 400021043 |           4193037 |          4200283 | SP2200001784  |             3814724 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           3808966 |          3814724 | FP2200445561  |                     | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           5429043 |          5452485 | NP2400000146  |             4200281 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           5429044 |          5452486 | NPA2400000094 |             3814724 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           4413481 |          4435829 | NPA2300000074 |             4200283 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           4413483 |          4435833 | FP2300169102  |                     | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           4193036 |          4200281 | NP2200001784  |             3814724 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           4193051 |          4200302 | SP2200001782  |             3814784 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           3809026 |          3814784 | FP2200445502  |                     | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           5429038 |          5452480 | NP2400000144  |             4200298 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           5429039 |          5452481 | NPA2400000092 |             3814784 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           4413468 |          4435812 | NPA2300000070 |             4200302 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           4413470 |          4435816 | FP2300169098  |                     | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           4193049 |          4200298 | NP2200001782  |             3814784 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           4193046 |          4200295 | SP2200001783  |             3814833 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           3809075 |          3814833 | FP2200445456  |                     | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           5429029 |          5452471 | NP2400000142  |             4200289 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           5429030 |          5452472 | NPA2400000090 |             3814833 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           4413476 |          4435824 | FP2300169100  |                     | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           4413474 |          4435820 | NPA2300000072 |             4200295 | 2022-06-01   | 2022-06-30  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           4193042 |          4200289 | NP2200001783  |             3814833 | 2022-06-01   | 2022-06-30  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           4193047 |          4200296 | SP2200001786  |             3887468 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           3881556 |          3887468 | FP2200514269  |                     | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           5429036 |          5452478 | NP2400000143  |             4200291 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           5429037 |          5452479 | NPA2400000091 |             3887468 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021030 |           4413480 |          4435828 | FP2300169101  |                     | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           4413475 |          4435822 | NPA2300000073 |             4200296 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021030 |           4193045 |          4200291 | NP2200001786  |             3887468 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           4193052 |          4200303 | SP2200001785  |             3887495 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           3881583 |          3887495 | FP2200514234  |                     | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           5429041 |          5452483 | NP2400000145  |             4200300 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           5429042 |          5452484 | NPA2400000093 |             3887495 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021032 |           4413469 |          4435814 | NPA2300000071 |             4200303 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           4413472 |          4435818 | FP2300169099  |                     | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021032 |           4193050 |          4200300 | NP2200001785  |             3887495 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           4193040 |          4200287 | SP2200001787  |             3887528 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           3881616 |          3887528 | FP2200514211  |                     | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           5429046 |          5452488 | NP2400000147  |             4200285 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           5429047 |          5452489 | NPA2400000095 |             3887528 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400021043 |           4413482 |          4435831 | NPA2300000075 |             4200287 | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           4413485 |          4435835 | FP2300169103  |                     | 2022-07-01   | 2022-07-31  | ENERGÍA XXI COMERCIALIZADORA DE REFERENCIA, S.L.U|
| 400021043 |           4193039 |          4200285 | NP2200001787  |             3887528 | 2022-07-01   | 2022-07-31  | MINISTERIO DEFENSA-DIREC.GENERAL INFRAESTRUCTURA|
| 400037842 |           5982972 |          6006911 | FP2400784319  |                     | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 400037842 |           6114296 |          6141317 | NPA2500002672 |             6006911 | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 400037842 |           6114327 |          6141386 | FP2500107142  |                     | 2024-11-15   | 2024-11-27  | NATURGY IBERIA, S.A. |
| 400037842 |           6114348 |          6141422 | FP2500107252  |                     | 2024-11-28   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 400037842 |           6114399 |          6141452 | NPA2500002669 |             6006911 | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 400037842 |           6114412 |          6141520 | FP2500107136  |                     | 2024-11-15   | 2024-11-27  | NATURGY IBERIA, S.A. |
| 400037842 |           6114447 |          6141559 | FP2500107251  |                     | 2024-11-28   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 100031621 |           5983275 |          6007214 | FP2400784013  |                     | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 100031621 |           6114339 |          6141396 | NPA2500002671 |             6007214 | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 100031621 |           6114354 |          6141440 | FP2500107140  |                     | 2024-11-15   | 2024-11-26  | NATURGY IBERIA, S.A. |
| 100031621 |           6114392 |          6141487 | FP2500107250  |                     | 2024-11-27   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 100031621 |           6114426 |          6141494 |               |             6007214 | 2024-11-15   | 2024-12-14  | NATURGY IBERIA, S.A. |
| 100031621 |           6114446 |          6141560 |               |                     | 2024-11-15   | 2024-11-26  | NATURGY IBERIA, S.A. |
| 100031621 |           6114459 |          6141572 |               |                     | 2024-11-27   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 133863002 |           5983368 |          6007307 | FP2400791829  |                     | 2024-11-15   | 2024-12-14  | ENDESA ENERGÍA, S.A.U.|
| 133863002 |           6114368 |          6141423 | NPA2500002670 |             6007307 | 2024-11-15   | 2024-12-14  | ENDESA ENERGÍA, S.A.U.|
| 133863002 |           6114388 |          6141483 | FP2500107138  |                     | 2024-11-15   | 2024-12-05  | ENDESA ENERGÍA, S.A.U.|
| 133863002 |           6114413 |          6141523 | FP2500107260  |                     | 2024-12-06   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 133863002 |           6114457 |          6141517 |               |             6007307 | 2024-11-15   | 2024-12-14  | ENDESA ENERGÍA, S.A.U.|
| 133863002 |           6114461 |          6141574 |               |                     | 2024-11-15   | 2024-12-05  | ENDESA ENERGÍA, S.A.U.|
| 133863002 |           6114465 |          6141578 |               |                     | 2024-12-06   | 2024-12-14  | NATURGY CLIENTES, S.A.U. |
| 132078004 |           5984586 |          6008532 | FP2400812502  |                     | 2024-11-22   | 2024-12-21  | ENDESA ENERGÍA, S.A.U.|
| 132078004 |           6114371 |          6141427 | NPA2500002677 |             6008532 | 2024-11-22   | 2024-12-21  | ENDESA ENERGÍA, S.A.U.|
| 132078004 |           6114391 |          6141486 | FP2500107149  |                     | 2024-11-22   | 2024-12-16  | ENDESA ENERGÍA, S.A.U.|
| 132078004 |           6114414 |          6141529 | FP2500107276  |                     | 2024-12-17   | 2024-12-21  | IBERDROLA CLIENTES, S.A.U.|
| 132078004 |           6114458 |          6141521 |               |             6008532 | 2024-11-22   | 2024-12-21  | ENDESA ENERGÍA, S.A.U.|
| 132078004 |           6114462 |          6141575 |               |                     | 2024-11-22   | 2024-12-16  | ENDESA ENERGÍA, S.A.U.|
| 132078004 |           6114466 |          6141579 |               |                     | 2024-12-17   | 2024-12-21  | IBERDROLA CLIENTES, S.A.U.|
| 400045893 |           5989693 |          6013639 | FP2400800830  |                     | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045893 |           6114342 |          6141395 | NPA2500002681 |             6013639 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045893 |           6114357 |          6141443 | FP2500107153  |                     | 2024-11-22   | 2024-12-16  | NATURGY IBERIA, S.A. |
| 400045893 |           6114398 |          6141496 | FP2500107277  |                     | 2024-12-17   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400045893 |           6114437 |          6141478 |               |             6013639 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045893 |           6114456 |          6141569 |               |                     | 2024-11-22   | 2024-12-16  | NATURGY IBERIA, S.A. |
| 400045893 |           6114463 |          6141576 |               |                     | 2024-12-17   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400045410 |           5990305 |          6014251 | FP2400800234  |                     | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045410 |           6114343 |          6141401 | NPA2500002680 |             6014251 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045410 |           6114359 |          6141446 | FP2500107152  |                     | 2024-11-22   | 2024-11-25  | NATURGY IBERIA, S.A. |
| 400045410 |           6114397 |          6141495 | FP2500107249  |                     | 2024-11-26   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400045410 |           6114432 |          6141497 |               |             6014251 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400045410 |           6114455 |          6141568 |               |                     | 2024-11-22   | 2024-11-25  | NATURGY IBERIA, S.A. |
| 400045410 |           6114464 |          6141577 |               |                     | 2024-11-26   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400016689 |           5990372 |          6014318 | FP2400800170  |                     | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400016689 |           6114280 |          6141301 | NPA2500002704 |             6014318 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400016689 |           6114307 |          6141364 | FP2500107178  |                     | 2024-11-22   | 2024-12-08  | NATURGY IBERIA, S.A. |
| 400016689 |           6114346 |          6141415 | FP2500107271  |                     | 2024-12-09   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400016689 |           6114385 |          6141445 | NPA2500002676 |             6014318 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 400016689 |           6114409 |          6141514 | FP2500107148  |                     | 2024-11-22   | 2024-12-08  | NATURGY IBERIA, S.A. |
| 400016689 |           6114439 |          6141552 | FP2500107270  |                     | 2024-12-09   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 132138003 |           5990475 |          6014421 | FP2400800066  |                     | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 132138003 |           6114341 |          6141393 | NPA2500002682 |             6014421 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 132138003 |           6114356 |          6141442 | FP2500107154  |                     | 2024-11-22   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 132138003 |           6114403 |          6141472 | NPA2500002675 |             6014421 | 2024-11-22   | 2024-12-21  | NATURGY IBERIA, S.A. |
| 132138003 |           6114417 |          6141530 | FP2500107147  |                     | 2024-11-22   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400033140 |           5998149 |          6022095 | FP2400799796  |                     | 2024-11-22   | 2024-12-21  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400033140 |           6114336 |          6141388 | NPA2500002683 |             6022095 | 2024-11-22   | 2024-12-21  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400033140 |           6114350 |          6141432 | FP2500107155  |                     | 2024-11-22   | 2024-12-05  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400033140 |           6114393 |          6141488 | FP2500107261  |                     | 2024-12-06   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400033140 |           6114429 |          6141464 |               |             6022095 | 2024-11-22   | 2024-12-21  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400033140 |           6114450 |          6141563 |               |                     | 2024-11-22   | 2024-12-05  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400033140 |           6114460 |          6141573 |               |                     | 2024-12-06   | 2024-12-21  | NATURGY CLIENTES, S.A.U. |
| 400000883 |           6032085 |          6056052 | FP2500020118  |                     | 2024-12-08   | 2025-01-07  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400000883 |           6114224 |          6141214 | NPA2500002782 |             6056052 | 2024-12-08   | 2025-01-07  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400000883 |           6114264 |          6141295 | FP2500107267  |                     | 2024-12-08   | 2024-12-19  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400000883 |           6114305 |          6141362 | FP2500107282  |                     | 2024-12-20   | 2025-01-07  | ENDESA ENERGÍA, S.A.U.|
| 400000883 |           6114377 |          6141438 | NPA2500002777 |             6056052 | 2024-12-08   | 2025-01-07  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400000883 |           6114407 |          6141513 | FP2500107262  |                     | 2024-12-08   | 2024-12-19  | COMERCIALIZADORA ELÉCTRICA DE CÁDIZ|
| 400000883 |           6114438 |          6141551 | FP2500107281  |                     | 2024-12-20   | 2025-01-07  | ENDESA ENERGÍA, S.A.U.|
| 400027251 |           6032752 |          6056719 | FP2500019772  |                     | 2024-12-08   | 2025-01-07  | NATURGY IBERIA, S.A. |
| 400027251 |           6114225 |          6141213 | NPA2500002781 |             6056719 | 2024-12-08   | 2025-01-07  | NATURGY IBERIA, S.A. |
| 400027251 |           6114265 |          6141296 | FP2500107266  |                     | 2024-12-08   | 2024-12-30  | NATURGY IBERIA, S.A. |
| 400027251 |           6114306 |          6141363 | FP2500107285  |                     | 2024-12-31   | 2025-01-07  | NATURGY CLIENTES, S.A.U. |
| 400027251 |           6114376 |          6141436 | NPA2500002778 |             6056719 | 2024-12-08   | 2025-01-07  | NATURGY IBERIA, S.A. |
| 400027251 |           6114404 |          6141509 | FP2500107263  |                     | 2024-12-08   | 2024-12-30  | NATURGY IBERIA, S.A. |
| 400027251 |           6114436 |          6141550 | FP2500107284  |                     | 2024-12-31   | 2025-01-07  | NATURGY CLIENTES, S.A.U. |
