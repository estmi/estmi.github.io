# C - Incongruencias Tipo de pago y grupo de pago

## Polisses amb incongruencies

```sql
SELECT
    pol.payment_mode_id, pol.tipo_pago,
    modcon.payment_mode_id, modcon.tipo_pago
FROM giscedata_polissa pol
LEFT JOIN giscedata_polissa_modcontractual modcon ON modcon.id = pol.modcontractual_activa
WHERE pol.id IN (2873, 5358, 9187, 10676, 14293, 14774, 15459, 15508, 23467, 23996, 27367, 33074, 34864, 39429, 41097, 41620, 43133, 43921, 44474, 53687, 59874, 60445, 60506, 60797, 62617, 63582, 63582, 65029, 67086, 70948, 71451, 71451, 71452, 71453, 71454, 72394, 74746, 74765, 77083, 79268, 85736, 85736, 85867, 86069, 86576, 86620, 87435, 88296, 88523, 88984, 89006, 89006, 89008, 89010, 89011, 89012, 89013, 89014, 89015, 89018, 89019, 89020, 89021, 89022, 89023, 89025, 89026, 89027, 89028, 89029, 89031, 89033, 89034, 89035, 89036, 89037, 89038, 89040, 89041, 89042, 89043, 89044, 89046, 89049, 89052, 89054, 89056, 89057, 89058, 89059, 89060, 89061, 89062, 89063, 89064, 89065, 89067, 89067, 89071, 89072, 89073, 89074, 89078, 89079, 89080, 89081, 89082, 89084, 89086, 89087, 89088, 89089, 89091, 89092, 89093, 89095, 89096, 89097, 89100, 89101, 89167);
```

## SQL per obtenir els que s'han de modificar

```sql
SELECT pol.id
FROM giscedata_polissa pol
LEFT JOIN giscedata_polissa_modcontractual modcon ON modcon.id = pol.modcontractual_activa
LEFT JOIN payment_mode pm on pm.id = pol.payment_mode_id
WHERE pm.type <> pol.tipo_pago;
```

```sql
BEGIN;
-- Modcons
UPDATE giscedata_polissa_modcontractual mod
SET tipo_pago = (
    SELECT
        type
    FROM payment_mode pm
    WHERE
        pm.id = mod.payment_mode_id
    )
WHERE mod.id in (
    SELECT
        modcon.id
    FROM giscedata_polissa_modcontractual modcon
    LEFT JOIN payment_mode pm ON pm.id = modcon.payment_mode_id
    WHERE
        pm.type <> modcon.tipo_pago);
-- Polisses
UPDATE giscedata_polissa pol
SET tipo_pago = (
    SELECT
        type
    FROM payment_mode pm
    WHERE
        pm.id = pol.payment_mode_id
    )
WHERE pol.id in (
    SELECT
        pol.id
    FROM giscedata_polissa pol
    LEFT JOIN payment_mode pm ON pm.id = pol.payment_mode_id
    WHERE
        pm.type <> pol.tipo_pago);
-- Factures
UPDATE account_invoice inv
SET payment_type = (
    SELECT
        type
    FROM payment_mode pm
    WHERE
        pm.id = (select payment_mode_id from giscedata_facturacio_factura where invoice_id = inv.id)
    )
WHERE inv.id in (
    SELECT
        inv.id
    FROM giscedata_facturacio_factura fac
    LEFT JOIN account_invoice inv ON inv.id = fac.invoice_id
    LEFT JOIN payment_mode pm ON pm.id = fac.payment_mode_id
    WHERE
        pm.type <> inv.payment_type);
```
