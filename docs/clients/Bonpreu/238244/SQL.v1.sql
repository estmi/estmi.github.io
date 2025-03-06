select sw.cups_id
from giscedata_switching_c1_02 c102
left join sw_step_header_rebuig_ref refreb on refreb.header_id = c102.header_id
left join giscedata_switching_rebuig rebuig on rebuig.id = refreb.rebuig_id
left join giscedata_switching_step_info info on info.pas_id= 'giscedata.switching.c1.02,' || c102.id
left join giscedata_switching sw on sw.id = info.sw_id
where rebuig = 't' and rebuig.motiu_rebuig = 3 and sw.create_date >= to_Date('20240101', 'YYYYMMDD');