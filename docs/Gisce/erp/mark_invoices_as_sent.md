# Marcar facturas como enviadas por email

## Obtener los ids de las facturas afectadas

Menú :arrow_right: Facturación :arrow_right: General :arrow_right: Facturas Cliente :arrow_right: Facturas pendiente de enviar por email

![get_ids]

## Revisión de los datos y ejecución de la actualización

```sql
-- Revisamos situacion actual
abenergia=# SELECT enviat FROM giscedata_facturacio_factura WHERE id IN (3235674, 2122494, 2099480, 688987);

   id    | enviat 
---------+--------
  688987 | f
 2099480 | f
 2122494 | f
 3235674 | f
(4 rows)

-- Actualizamos
abenergia=# BEGIN; UPDATE giscedata_facturacio_factura SET enviat = 't' WHERE id IN (3235674, 2122494, 2099480, 688987);
BEGIN
UPDATE 4

-- Revisamos nueva situacion
abenergia=*# SELECT enviat FROM giscedata_facturacio_factura WHERE id IN (3235674, 2122494, 2099480, 688987);
   id    | enviat 
---------+--------
  688987 | t
 2099480 | t
 2122494 | t
 3235674 | t
(4 rows)

-- Guardamos los cambios
abenergia=*# COMMIT;
COMMIT
```

[get_ids]: ../mark_invoice_as_sent/get_ids.png
