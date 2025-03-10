select 
    name
    , sum(coalesce("end", current_timestamp)-start) as time
    , sum(num_jobs)
    , sum((coalesce("end", current_timestamp)-start)/num_jobs) as timeXjob, avg(coalesce("end", current_timestamp)-start) as avg
from oorq_jobs_group
where 
    name ilike '%Validar%2024' 
    or name ilike '%Validar%2025' 
group by name
ORDER BY 
  TO_DATE(SUBSTRING(name FROM '(\d{2}/\d{4})'), 'MM/YYYY') DESC;