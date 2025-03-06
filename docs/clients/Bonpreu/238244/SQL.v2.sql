Select cups.name
from giscedata_switching_c2_01 c201
left join giscedata_switching_step_info infoc2 on infoc2.pas_id = 'giscedata.switching.c2.01,' || c201.id
left join giscedata_switching swc2 on swc2.id = infoc2.sw_id
left join giscedata_cups_ps cups on cups.id = swc2.cups_id
where swc2.cups_id in (
select sw.cups_id
from giscedata_switching_c1_02 c102
left join sw_step_header_rebuig_ref refreb on refreb.header_id = c102.header_id
left join giscedata_switching_rebuig rebuig on rebuig.id = refreb.rebuig_id
left join giscedata_switching_step_info info on info.pas_id = 'giscedata.switching.c1.02,' || c102.id
left join giscedata_switching sw on sw.id = info.sw_id
where rebuig = 't' and rebuig.motiu_rebuig = 3 and sw.create_date >= to_Date('20240101', 'YYYYMMDD'))
order by cups.name;