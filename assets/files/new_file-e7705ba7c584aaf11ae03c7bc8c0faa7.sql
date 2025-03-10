SELECT
            cups.name as "CUPS",
            pol.name as "Contracte",
            inv.number AS "Factura",
            '-' as "NroFactura_F1_distribuidora",
            part.vat as "Nif_RazonSocial",
            part.name as "Nom client",
            tarifaatr.name as "Tarifa d'acces",
            gfl.name as "lot facturacio",
			COALESCE( to_char(fact.data_inici::date, 'DD/MM/YYYY'), ' ') as "Data inicial",
			COALESCE( to_char(fact.data_final::date, 'DD/MM/YYYY'), ' ') as "Data final",
			inv.date_invoice as "Data factura",
			inv.date_due as "Fecha vencimiento",
			CASE WHEN fact.tipo_rectificadora='A' THEN 'Anuladora'
			   WHEN fact.tipo_rectificadora='B' THEN 'Anuladora+Rectificadora'
			   WHEN fact.tipo_rectificadora='R' THEN 'Rectificadora'
			   WHEN fact.tipo_rectificadora='RA' THEN 'Rectificadora sin anuladora'
			   WHEN fact.tipo_rectificadora='BRA' THEN 'Anuladora (ficticia)'
			   ELSE 'Normal'
			   END AS "tipo factura",
			pt.name as "tipo pago",
			distri.name as "Distribuidoroa",
			rpa_fiscal.street as "Dirección fiscal",
            rpa_fiscal.zip as "codigo postal fiscal",
            coalesce(rm_fiscal.name, '') as "municipio fiscal",
            coalesce(rp_fiscal.name, '') as "poblacion fiscal",
            coalesce(rcs_fiscal.name, '') as "provincia fiscal",
            rpb.iban as "Dom_Bancaria",
            pm.name as "ReferenciaSEPA",
			inv.state as "Estado factura",
            fact.energia_kwh,
            COALESCE( (SELECT sum(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
           JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0) as "reactiva_Kvarh",
-- TERMES POTENCIA
			COALESCE( (SELECT  AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0) as "Term_Pot_P1_€",

            COALESCE( (SELECT AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0) as "Term_Pot_P2_€",

            COALESCE( (SELECT AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0) as "Term_Pot_P3_€",

            COALESCE( (SELECT AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0) as "Term_Pot_P4_€",

            COALESCE( (SELECT AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0) as "Term_Pot_P5_€",

            COALESCE( (SELECT AVG(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0) as "Term_Pot_P6_€",

            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            ), 0) as "Termino_Potencia_€",

            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'exces_potencia'
            ), 0) as "Excesos_Potencia_€",
-- ENERGIA
            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P1'
            ), 0) as "Term_Activa_P1_€",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P2'
            ), 0) as "Term_Activa_P2_€",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P3'
            ), 0) as "Term_Activa_P3_€",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P4'
            ), 0) as "Term_Activa_P4_€",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P5'
            ), 0) as "Term_Activa_P5_€",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.price_subtotal ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P6'
            ), 0) as "Term_Activa_P6_€",
            fact.total_energia as "Termino_Activa_€",
            fact.total_reactiva as "Termino_Reactiva_€",
            fact.total_generacio as "Termino_Autoconsum_€",

-- DESCUENTOS
            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%potencia%'
            ), 0) as "Descuento Cargos Potencia euros",

            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'DESC1721' AND linia.name ilike '%energia%'
            ), 0) as "Descuento Cargos Energia euros",

            COALESCE( (
            SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
                and flinia.isdiscount = True
            	AND (prod.default_code != 'DESC1721' or prod.default_code is null)
            ), 0) as "Descuento",

            COALESCE( (SELECT sum(linia.price_subtotal)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            JOIN product_uom uom ON uom.id=linia.uos_id
            JOIN product_product prod ON prod.id = linia.product_id
            WHERE linia.invoice_id = inv.id
            AND (flinia.tipus = 'altres' OR flinia.tipus is Null)
            AND prod.default_code = 'CFINANCERELEC'
            ), 0) as "Coste financiero",
			case
				when it_iese.name like '%MWh%'
				   then coalesce((SELECT sum(linia.price_subtotal)
                          FROM account_invoice_line linia
                          inner join account_invoice_line_tax linia_tax on linia_tax.invoice_line_id = linia.id
                          inner join account_tax atax on atax.id = linia_tax.tax_id and atax.name like '%electrici%'
                          WHERE linia.invoice_id = inv.id)
                        ,0)
				else COALESCE(it_iese.factor_base_amount,0)
			end  AS "Base IESE EUR",
			case
				when it_iese.name like '%MWh%'
				   then COALESCE(it_iese.factor_base_amount,0)
           else 0
			end AS "Base IESE MWh",
			case
				when pol.article_560 != 'sin' and pol.article_560 is not null
				   then pol.percentatge_560
				else 100.0
			end  as Porcentaje_CAE,
			COALESCE(it_iese.tax_amount,0) AS "total IESE",
			COALESCE(it_iese.name,'') AS "Tipo IESE",
			fact.total_lloguers  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "ALQUILEREQUIPO",
			COALESCE(altres.altres, 0) * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "otros conceptos",
		    COALESCE(it_10.name, '') AS IVA1,
   		    COALESCE(it_10.base,0)  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "Base IVA1",
		    COALESCE(it_10.amount,0)  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "total iva1",
            it_21.names as "IVA2",
            it_21.base AS "Base IVA1",
            it_21.amount AS "Total iva1",
      COALESCE(it_0.name, '') AS IVA3,
      COALESCE(it_0.base,0)  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "Base IVA3",
      COALESCE(it_0.amount,0)  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "total iva3",
   		    it_total_iva.total as "importe_iva",
		    no_iva_concepts.base_costs as "Concepto_Sin_IVA",
            inv.amount_untaxed * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "Base bruta",
		    inv.amount_total  * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS "Total_Final",
		    inv.residual * (CASE WHEN inv.type like '%%_refund' THEN -1 ELSE 1 END) AS RESIDUAL,

		    -- ENERGIA KW

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P1'
            ), 0) as "Energia P1 (kWh)",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P2'
            ), 0) as "Energia P2 (kWh)",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P3'
            ), 0) as "Energia P3 (kWh)",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P4'
            ), 0) as "Energia P4 (kWh)",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P5'
            ), 0) as "Energia P5 (kWh)",
            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            AND linia.name = 'P6'
            ), 0) as "Energia P6 (kWh)",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'energia'
            ), 0) as "Total_Energia_Activa_kWh",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P1'
            ), 0) as "reactiva P1 kVAr",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P2'
            ), 0) as "reactiva P2 kVAr",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P3'
            ), 0) as "reactiva P3 kVAr",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P4'
            ), 0) as "reactiva P4 kVAr",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P5'
            ), 0) as "reactiva P5 kVAr",

            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            AND linia.name = 'P6'
            ), 0) as "reactiva P6 kVAr",
            COALESCE( (SELECT SUM(CASE WHEN flinia.isdiscount=false THEN linia.quantity ELSE 0 END)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'reactiva'
            ), 0) as "Total_Energia_Reactiva_kVAr",
            -- Potencia contractada
              coalesce(pot_contractades.pot_cont[1],0) as "PotContP1",
			  coalesce(pot_contractades.pot_cont[2],0) as "PotContP2",
			  coalesce(pot_contractades.pot_cont[3],0) as "PotContP3",
			  coalesce(pot_contractades.pot_cont[4],0) as "PotContP4",
			  coalesce(pot_contractades.pot_cont[5],0) as "PotContP5",
			  coalesce(pot_contractades.pot_cont[6],0) as "PotContP6",
            -- Potencia facturada
            COALESCE( (SELECT  AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0) as "Potencia Fac P1 (KW)",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0) as "Potencia Fac P2 (KW)",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0) as "Potencia Fac P3 (KW)",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0) as "Potencia Fac P4 (KW)",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0) as "Potencia Fac P5 (KW)",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0) as "Potencia Fac P6 (KW)",

          -- Potencia maxima
		  coalesce(potencia_maxima.maximetre[1],0) as "Pot_MaxDem_P1_KW",
		  coalesce(potencia_maxima.maximetre[2],0) as "Pot_MaxDem_P2_KW",
		  coalesce(potencia_maxima.maximetre[3],0) as "Pot_MaxDem_P3_KW",
		  coalesce(potencia_maxima.maximetre[4],0) as "Pot_MaxDem_P4_KW",
		  coalesce(potencia_maxima.maximetre[5],0) as "Pot_MaxDem_P5_KW",
		  coalesce(potencia_maxima.maximetre[6],0) as "Pot_MaxDem_P6_KW",
          -- Excedents
		  COALESCE( (SELECT  AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0) as "Excedents P1 kwh",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0) as "Excedents P2 kwh",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0) as "Excedents P3 kwh",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0) as "Excedents P4 kwh",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0) as "Excedents P5 kwh",

            COALESCE( (SELECT AVG(linia.quantity)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0) as "Excedents P6 kwh",
          llista.name as "Tarifa de comercialitzadora",
		  -- PREU ENERGIA
            COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P1')
			, 0) as "Preu Energia P1",


			COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P2')
			, 0) as "Preu Energia P2",

			COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P3')
			, 0) as "Preu Energia P3",

			COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P4')
			, 0) as "Preu Energia P4",

			COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P5')
			, 0) as "Preu Energia P5",

			COALESCE(
				(SELECT
					round(
						CASE WHEN (SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END) > 0) THEN (SUM(linia.price_subtotal)/SUM(CASE WHEN flinia.isdiscount = false THEN linia.quantity ELSE 0 END)) ELSE (0) END
					, 6)
				FROM giscedata_facturacio_factura_linia flinia
				JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
				WHERE linia.invoice_id = inv.id
				AND flinia.tipus = 'energia'
				AND linia.name = 'P6')
			, 0) as "Preu Energia P6",
			pol.coeficient_k as "Gastos_Operativos_€/MWh",
            (fact.data_final -fact.data_inici) + 1 as "dias",
			COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P1'
            ), 0) as "Preu Potencia P1",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P2'
            ), 0) as "Preu Potencia P2",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P3'
            ), 0) as "Preu Potencia P3",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P4'
            ), 0) as "Preu Potencia P4",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P5'
            ), 0) as "Preu Potencia P5",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'potencia'
            AND linia.name = 'P6'
            ), 0) as "Preu Potencia P6",
            -- PREU excedents
            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P1'
            ), 0) as "Preu generacio P1",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P2'
            ), 0) as "Preu generacio P2",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P3'
            ), 0) as "Preu generacio P3",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P4'
            ), 0) as "Preu generacio P4",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P5'
            ), 0) as "Preu generacio P5",

            COALESCE( (SELECT AVG(flinia.price_unit_multi)
            FROM giscedata_facturacio_factura_linia flinia
            JOIN account_invoice_line linia ON linia.id=flinia.invoice_line_id
            WHERE linia.invoice_id = inv.id
            AND flinia.tipus = 'generacio'
            AND linia.name = 'P6'
            ), 0) as "Preu generacio P6",

            COALESCE(
             (SELECT case
                  when max(glo.codi) = '99' then 'SIN LECTURA'
                  when max(glo.codi) not in ('40') then 'REAL'
                  else 'ESTIMADA'
                  end

            FROM giscedata_facturacio_lectures_energia AS lect
            inner join giscedata_lectures_origen glo on lect.origen_id = glo.id
            WHERE lect.factura_id = fact.id
            AND lect.magnitud = 'AE'
            AND lect.tipus = 'activa'), 'Real') AS "Tipo_Entrada",
            comercial.name as comercial



        FROM
                giscedata_facturacio_factura fact
                LEFT JOIN account_invoice inv ON inv.id=fact.invoice_id
                LEFT JOIN res_partner_address rpa_fiscal  ON rpa_fiscal.id=inv.address_invoice_id
		        left join res_municipi rm_fiscal on rm_fiscal.id = rpa_fiscal.id_municipi
		        left join res_poblacio rp_fiscal on rp_fiscal.id = rpa_fiscal.id_poblacio
		        left join res_country_state rcs_fiscal on rcs_fiscal.id = rpa_fiscal.state_id
                LEFT JOIN giscedata_polissa_tarifa tarifaatr ON tarifaatr.id=fact.tarifa_acces_id
                left join giscedata_facturacio_lot gfl on gfl.id = fact.lot_facturacio
                LEFT JOIN giscedata_polissa pol ON pol.id=fact.polissa_id
                LEFT JOIN giscedata_cups_ps cups ON cups.id=pol.cups
                LEFT JOIN product_pricelist llista ON llista.id=fact.llista_preu
                LEFT JOIN res_partner part ON part.id=inv.partner_id
                LEFT JOIN res_municipi mun ON mun.id=cups.id_municipi
                LEFT JOIN giscedata_facturacio_factura as rectificada ON rectificada.id=fact.ref
                LEFT JOIN account_invoice irectificada ON irectificada.id=rectificada.invoice_id
                left join payment_type pt on pol.tipo_pago = pt.id
                inner join res_partner distri on distri.id = pol.distribuidora
                left join res_partner_bank rpb on rpb.id = inv.partner_bank
                left join payment_mandate pm on pm.id = inv.mandate_id
                LEFT JOIN account_invoice_tax it_iese ON (it_iese.invoice_id=inv.id AND (it_iese.name LIKE '%%electricidad%%' or it_iese.name LIKE '%%electricitat%%'))
                LEFT JOIN account_invoice_tax it_10 ON (it_10.invoice_id=inv.id AND (it_10.name LIKE 'IVA 10%%' OR it_10.name LIKE '10%%%% IVA%%' or it_10.name LIKE 'IVA 5%%' OR it_10.name LIKE '5%%%% IVA%%'))
                LEFT JOIN ( select foo.invoice_id, sum(amount) as total from account_invoice_tax foo  where foo.name LIKE '%%IVA%%' group by foo.invoice_id) as it_total_iva ON (it_total_iva.invoice_id=inv.id)
				LEFT JOIN (select invoice_id, sum(amount) as amount, sum(base) as base, string_agg(inner_it_21.name,',') as names from account_invoice_tax inner_it_21 where (inner_it_21.name LIKE 'IVA 21%%' OR inner_it_21.name LIKE '21%%%% IVA%%') group by invoice_id) it_21 ON (it_21.invoice_id=inv.id)
        LEFT JOIN account_invoice_tax it_0 ON (it_0.invoice_id=inv.id AND (it_0.name LIKE 'IVA 0%%' OR it_0.name LIKE '0%%%% IVA%%'))
				LEFT JOIN (
				  SELECT lf.factura_id AS factura_id,SUM(li.price_subtotal) AS altres
				  FROM giscedata_facturacio_factura_linia lf
				  LEFT JOIN account_invoice_line li ON (li.id=lf.invoice_line_id)
				  LEFT JOIN product_product pp ON (li.product_id = pp.id)
				  WHERE ((pp.id is not null and coalesce(pp.default_code,'') not in ('DESC1721', 'CON06','FIANZA', 'CFINANCERELEC')) or pp.id is null)
				  AND lf.tipus='altres'
				  GROUP BY lf.factura_id
				) AS altres ON (altres.factura_id=fact.id)
				LEFT JOIN (
				  SELECT il.invoice_id AS inv_id, SUM(il.price_subtotal) AS base_costs, 0 AS iva_costs
				  FROM account_invoice_line il
				  LEFT JOIN account_invoice_line_tax lt ON (lt.invoice_line_id = il.id)
				  LEFT JOIN account_tax it_21 ON (lt.tax_id=it_21.id)
				  LEFT JOIN giscedata_facturacio_factura_linia fl ON (fl.invoice_line_id = il.id)
				  WHERE it_21.id IS NULL
				    AND fl.tipus = 'altres'
				  GROUP BY il.invoice_id, it_21.amount
				) no_iva_concepts ON (no_iva_concepts.inv_id = inv.id)
				LEFT JOIN (
				  select polissa_id, array_agg(pot_cont  ORDER BY name ASC ) as pot_cont
				  from (
				      select polissa_id, ppcp.potencia as pot_cont, pt.name as name
				      from giscedata_polissa_potencia_contractada_periode ppcp
				      inner join giscedata_polissa_tarifa_periodes gptp on (gptp.id = ppcp.periode_id)
				      inner join product_product pp on (pp.id = gptp.product_id)
				      inner join (select * from product_template order by name) pt on (pp.product_tmpl_id = pt.id)
				      order by pt.name
				    ) as foo
				    group by foo.polissa_id
				) pot_contractades on (pot_contractades.polissa_id = fact.polissa_id)
				LEFT JOIN (
				  SELECT array_agg(name) as periodes,
				    array_agg(pot_maximetre) as maximetre,
				    factura_id
				  FROM (SELECT l.name,
				      l.pot_maximetre,
				      l.factura_id
				   FROM giscedata_facturacio_lectures_potencia l
				   --where l.factura_id in (fact.id)
				   GROUP BY l.factura_id, l.name, l.pot_maximetre
				       ORDER BY l.factura_id, l.name) as foo
				  GROUP BY foo.factura_id
				) as potencia_maxima ON (potencia_maxima.factura_id = fact.id)
        left join hr_employee comercial on comercial.id = pol.comercial_id
         WHERE
                inv.type in ('out_invoice', 'out_refund')
                AND inv.state in ('paid', 'open')
    AND inv.date_invoice BETWEEN '$fecha_emision_desde' AND '$fecha_emision_hasta'
