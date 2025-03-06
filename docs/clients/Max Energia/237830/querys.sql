-- Colaboradors:

select id from hr_colaborador where parent_id in (1, 12, 11, 10) or id = 1;

-- Update Colaboradors

update hr_colaborador set giscedata_coste_operativo_2_20td=8, giscedata_coste_operativo_2_30td=8, giscedata_coste_operativo_2_6xtd=8 where parent_id in (1, 12, 11, 10) or id = 1;


-- Ids leads colaboradors

select giscedata_crm_lead_id from hr_colaborador_giscedata_crm_lead where colaborador_id in 
(select id from hr_colaborador where parent_id in (1, 12, 11, 10) or id = 1);


-- Ids Leads

select lead.id from giscedata_crm_lead lead join crm_case crm ON crm.id=lead.crm_id where lead.id in (select giscedata_crm_lead_id from hr_colaborador_giscedata_crm_lead where colaborador_id in (select id from hr_colaborador where parent_id in (1, 12, 11, 10) or id = 1)) and state in ('draft', 'open', 'pending') and coste_operativo_2 = 5;

-- Update Leads (PRE:171)

Update 
    giscedata_crm_lead lead 
set 
    coste_operativo_2 = 8 
where 
    lead.id 
        in (select lead.id from giscedata_crm_lead lead join crm_case crm ON crm.id=lead.crm_id where lead.id in (select giscedata_crm_lead_id from hr_colaborador_giscedata_crm_lead where colaborador_id in (select id from hr_colaborador where parent_id in (1, 12, 11, 10) or id = 1)) and state in ('draft', 'open', 'pending') and coste_operativo_2 = 5);

-- Ofertes simples

select 
    oferta.id 
from 
    giscemisc_oferta_simple oferta 
where oferta.id 
        in (select 
                giscemisc_opo_id 
            from 
                hr_colaborador_giscemisc_oferta_simple 
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state in ('init', 'calc')
    and oferta.coste_operativo_2 = 5;

-- Update Ofertes simples (PRE:0)

update 
    giscemisc_oferta_simple oferta
set 
    coste_operativo_2 = 8 
where oferta.id 
        in (select 
                oferta.id 
            from 
                giscemisc_oferta_simple oferta 
            where oferta.id 
                    in (select 
                            giscemisc_opo_id 
                        from 
                            hr_colaborador_giscemisc_oferta_simple 
                        where colaborador_id 
                                in (select 
                                        id 
                                    from 
                                        hr_colaborador 
                                    where 
                                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state in ('init', 'calc')
    and oferta.coste_operativo_2 = 5);

-- Ids Polisses

select 
    pol.id 
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa')
    and pol.coste_operativo_2 = 5;

-- Update Polisses (PRE:5)

update 
    giscedata_polissa pol
set 
    coste_operativo_2 = 8 
where pol.id 
        in (select 
                pol.id 
            from 
                giscedata_polissa pol 
            where pol.id 
                    in (select 
                            polissa_id 
                        from 
                            hr_colaborador_giscedata_polissa
                        where colaborador_id 
                                in (select 
                                        id 
                                    from 
                                        hr_colaborador 
                                    where 
                                        parent_id in (1, 12, 11, 10) or id = 1
                                        )
                            ) 
    and state not in ('cancelada', 'baixa')
    and pol.coste_operativo_2 = 5);

-- Ids ModCons

select modcon.id from giscedata_polissa_modcontractual modcon where modcon.polissa_id in (select 
    pol.id 
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa')
    and pol.coste_operativo_2 = 5)
and modcon.coste_operativo_2 = 5;

-- Update ModCons

update giscedata_polissa_modcontractual set coste_operativo_2 = 8 
where id in (select modcon.id from giscedata_polissa_modcontractual modcon where modcon.polissa_id in (select 
    pol.id 
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa')
    and pol.coste_operativo_2 = 5)
and modcon.coste_operativo_2 = 5);


begin;
select 
  pol.coste_operativo_2, count(*)
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa') group by pol.coste_operativo_2;
update 
    giscedata_polissa pol
set 
    coste_operativo_2 = 8 
where pol.id 
        in (select 
                pol.id 
            from 
                giscedata_polissa pol 
            where pol.id 
                    in (select 
                            polissa_id 
                        from 
                            hr_colaborador_giscedata_polissa
                        where colaborador_id 
                                in (select 
                                        id 
                                    from 
                                        hr_colaborador 
                                    where 
                                        parent_id in (1, 12, 11, 10) or id = 1
                                        )
                            )

    and state not in ('cancelada', 'baixa')
    and (pol.coste_operativo_2 != -6 or pol.coste_operativo_2 is null));
select 
  pol.coste_operativo_2, count(*)
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa') group by pol.coste_operativo_2;

update giscedata_polissa_modcontractual set coste_operativo_2 = 8 
where id in (select modcon.id from giscedata_polissa_modcontractual modcon where modcon.polissa_id in (select 
    pol.id 
from 
    giscedata_polissa pol 
where pol.id 
        in (select 
                polissa_id 
            from 
                hr_colaborador_giscedata_polissa
            where colaborador_id 
                in (select 
                        id 
                    from 
                        hr_colaborador 
                    where 
                        parent_id in (1, 12, 11, 10) or id = 1)
            ) 
    and state not in ('cancelada', 'baixa')
    and (pol.coste_operativo_2 != -6 or pol.coste_operativo_2 is null )));
    