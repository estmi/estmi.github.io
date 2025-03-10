# [243721] Comer - Procés VALIDAR facturació

## 1

```sql
select 
    name
    , sum(coalesce("end", current_timestamp)-start) as time
    , sum(num_jobs)
    , sum((coalesce("end", current_timestamp)-start)/num_jobs) as timeXjob
    , avg(coalesce("end", current_timestamp)-start) as avg
from oorq_jobs_group
where 
    name ilike '%Validar%2024' 
    or name ilike '%Validar%2025' 
group by name
ORDER BY 
    TO_DATE(SUBSTRING(name FROM '(\d{2}/\d{4})'), 'MM/YYYY') DESC;
```

|        name         |   time   |  sum  |    timexjob     |       avg       |
|---------------------|----------|-------|-----------------|-----------------|
| Validar Lot 02/2025 | 19:46:22 |  9597 | 00:00:31.055769 | 04:56:35.5|
| Validar Lot 01/2025 | 10:31:09 |  6874 | 00:00:55.263938 | 01:30:09.857143|
| Validar Lot 12/2024 | 13:01:23 |  7860 | 00:01:31.239753 | 01:18:08.3|
| Validar Lot 11/2024 | 10:54:19 | 20083 | 00:04:49.822812 | 00:31:09.47619|
| Validar Lot 10/2024 | 02:21:41 | 11011 | 00:00:54.492657 | 00:08:20.058824|
| Validar Lot 09/2024 | 04:09:23 | 19723 | 00:00:28.04528  | 00:16:37.533333|
| Validar Lot 08/2024 | 02:26:19 |  8512 | 00:00:51.638029 | 00:08:07.722222|
| Validar Lot 07/2024 | 02:13:21 |  7631 | 00:00:20.903733 | 00:14:49|
| Validar Lot 06/2024 | 03:07:14 | 10483 | 00:00:25.912542 | 00:15:36.166667|
| Validar Lot 05/2024 | 01:52:01 | 10648 | 00:00:08.04379  | 00:14:00.125|
| Validar Lot 04/2024 | 01:30:45 |  7102 | 00:00:09.538056 | 00:15:07.5|
| Validar Lot 03/2024 | 02:29:44 | 10425 | 00:00:14.87192  | 00:13:36.727273|
| Validar Lot 02/2024 | 01:53:36 |  8242 | 00:00:17.270778 | 00:12:37.333333|
| Validar Lot 01/2024 | 01:35:24 |  7590 | 00:00:32.908716 | 00:10:36|

## 2

```sql
select 
    name
    , sum(coalesce("end", current_timestamp)-start) as time
    , sum(num_jobs)
    , avg((coalesce("end", current_timestamp)-start)/num_jobs) as timeXjob
from oorq_jobs_group
where 
    name ilike '%Validar%2024'
    or name ilike '%Validar%2025'
GROUP BY 
    name
ORDER BY 
    TO_DATE(SUBSTRING(name FROM '(\d{2}/\d{4})'), 'MM/YYYY') DESC;
```