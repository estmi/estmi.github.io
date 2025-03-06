# Imports
from datetime import datetime

avui = datetime.strftime(datetime.now(), "%Y-%m-%d")


# Llistats auxiliars

def execute_llistat_contractes( cursor, uid, pol_ids):
    sql = """SELECT
                comp.name as "Marca",
                pol.name as "Codigo Contrato",
                cups.name as "CUPS",
                titular.name as "Titular",
                titular.vat as "NIF",
                cups.direccio as "Direccion",
                cups_mun.name as "Municipio",
                COALESCE(address.city, pobl.name) as "Poblacion",
                state.name as "Provincia",
                tarifa.name as "Tarifa",
    CASE WHEN pol.data_renovacio IS NULL THEN 'No' ELSE 'Si' END as "Renovado",
    ren.name as "Producto de Renovacion",
                bank.iban as "IBAN",
                address.zip as "Codigo Postal",
                fact_address.name as "Direccion facturacion",
                fact_mun.name as "Municipio Facturacion",
                fact_state.name as "Provincia Facturacion",
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
                --- Potencies Contractades
                pol.pressio as "Termino Fijo P1",
                -- ------
                COALESCE(
                    (SELECT pare.name from hr_colaborador_giscegas_polissa colpol
                    JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
                    JOIN hr_colaborador pare ON pare.id=fill.parent_id
                    WHERE colpol.polissa_id = pol.id
                    LIMIT 1),
                    (SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscegas_polissa colpol
                    JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
                    WHERE colpol.polissa_id = pol.id)
                ) as "Colaboradores Padre",
                (
                    SELECT STRING_AGG(fill.name, ', ') from hr_colaborador_giscegas_polissa colpol
                    JOIN hr_colaborador fill ON colpol.colaborador_id=fill.id
                    WHERE colpol.polissa_id = pol.id
                ) as "Colaboradores Hijos",
                pol.state as "Estado Contrato",
               (
                    SELECT STRING_AGG(pl.name, ', ') from giscegas_facturacio_services ser
                    JOIN product_pricelist pl ON pl.id=ser.llista_preus
                           WHERE ser.polissa_id=pol.id and ser.producte != 1703 and ( ser.data_fi is Null or ser.data_fi > CURRENT_DATE)
               ) as "Servicios Mantenimiento",
               (
                    SELECT STRING_AGG(pl.name, ', ') from giscegas_facturacio_services ser
                    JOIN product_pricelist pl ON pl.id=ser.llista_preus
                    WHERE ser.polissa_id=pol.id and ser.producte = 1703 and ( ser.data_fi is Null or ser.data_fi > CURRENT_DATE)
               ) as "Servicios Gestion",
                -- serveis contractats,
                grup.name as "Grupo de Pago",
                pol.data_alta as "Fecha Alta",
                pol.data_baixa as "Fecha Baja",
                cnae.name as "CNAE",
                pricelist.name as "Producto Contratado",
                mandate.name as "Referencia Mandato",
                mandate.date as "Fecha Mandato",
                pol.consum_anual_oferta_inicial as "Consumo anual oferta inicial"
            FROM
                giscegas_polissa pol
                LEFT JOIN giscegas_cups_ps cups ON cups.id=pol.cups
                LEFT JOIN res_partner_bank bank ON pol.bank=bank.id
                LEFT JOIN res_partner titular ON titular.id=pol.titular
                LEFT JOIN res_partner_address address ON pol.direccio_notificacio = address.id
                LEFT JOIN res_municipi cups_mun ON cups.id_municipi= cups_mun.id
                LEFT JOIN giscegas_polissa_tarifa tarifa ON tarifa.id=pol.tarifa
                LEFT JOIN payment_mode grup ON grup.id = pol.payment_mode_id
                LEFT JOIN res_company comp ON comp.id = pol.company_id
                LEFT JOIN res_country_state state ON state.id = cups_mun.state
                LEFT JOIN res_poblacio pobl ON cups.id_poblacio =  pobl.id
                LEFT JOIN giscemisc_cnae cnae ON cnae.id = pol.cnae
                LEFT JOIN res_partner_address fact_address ON pol.direccio_pagament=fact_address.id
                LEFT JOIN res_municipi fact_mun ON fact_address.id_municipi=fact_mun.id
                LEFT JOIN res_country_state fact_state ON fact_state.id=fact_mun.state
                LEFT JOIN res_subsistemas_electricos subs ON cups_mun.subsistema_id = subs.id
                LEFT JOIN product_pricelist pricelist ON pricelist.id = pol.llista_preu
                LEFT JOIN product_pricelist ren ON ren.id = pol.next_pricelist_id
                LEFT JOIN (
                    SELECT
                        reference,
                        MAX(date) as max_date
                    FROM
                        payment_mandate
                    GROUP BY
                        reference
                ) max_mandate ON split_part(max_mandate.reference, ',', 2)::int = pol.id
                LEFT JOIN payment_mandate mandate ON mandate.reference = max_mandate.reference AND mandate.date = max_mandate.max_date
            WHERE
                (pol.id in %s)
            """

    cursor.execute(sql, (tuple(pol_ids),))
    res = cursor.dictfetchall()
    return res


canarias = ['Fuerteventura-Lanzarote', 'Gran Canaria', 'Hierro', 'La Gomera', 'La Palma', 'Tenerife']
balears = ['Mallorca-Menorca', 'Ibiza-Formentera']

# Donem d'alta els models
pol_o = self.pool.get('giscegas.polissa')
cups_o = self.pool.get('giscegas.cups.ps')
partner_o = self.pool.get('res.partner')
comp_o = self.pool.get('res.company')
state_o = self.pool.get('res.country.state')
addr_o = self.pool.get('res.partner.address')
mun_o = self.pool.get('res.municipi')
subs_o = self.pool.get('res.subsistemas.electricos')
pot_o = self.pool.get('giscegas.polissa.potencia.contractada.periode')
per_o = self.pool.get('giscegas.polissa.tarifa.periodes')
temp_o = self.pool.get('product.template')
colab_o = self.pool.get('hr.colaborador')
colab_pol_o = self.pool.get('hr.colaborador.giscegas.polissa')
serv_o = self.pool.get('giscegas.facturacio.services')
mandate_o = self.pool.get('payment.mandate')

# Aconseguim les IDS de les polisses a Informar

comp_ids = comp_o.search(cursor, uid,
                         [('id', 'in', (1, 2, 3))])  # Primer aconseguim les ids de les companies que ens entren

pol_ids = pol_o.search(cursor, uid, [('company_id', 'in', comp_ids)], context={'active_test': False})  # Trobem les polisses amb la company id adient

res = []
try:
    # Llegim els camps a mostrar
    res = execute_llistat_contractes(cursor, uid, pol_ids)
except Exception as e:
    raise Exception(e)
