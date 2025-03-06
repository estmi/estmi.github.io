select id, name from giscedata_polissa where company_id = 5 and payment_mode_id is null;
BEGIN;
UPDATE giscedata_polissa_modcontractual SET payment_mode_id = 34 WHERE id in (select modcontractual_activa from giscedata_polissa where company_id = 5 and payment_mode_id is null and modcontractual_activa is not null);
UPDATE giscedata_polissa SET payment_mode_id = 34 WHERE company_id = 5 and payment_mode_id is null;
UPDATE giscegas_polissa_modcontractual SET payment_mode_id = 34 WHERE id in (select modcontractual_activa from giscegas_polissa where company_id = 5 and payment_mode_id is null and modcontractual_activa is not null);
UPDATE giscegas_polissa SET payment_mode_id = 34 WHERE company_id = 5 and payment_mode_id is null;