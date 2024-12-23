# Eliminar usuari Root

## Reanomenar usuari Root

Canviem el login de l'usuari `root` per `gisce` i la seva pertinent contrassenya.

```sql
BEGIN; UPDATE res_users SET login = 'gisce', password = '[###]', name = 'Gisce' WHERE id = 1;
```

## Crear Usuari nou 'Si fa falta'

Crear un usuari perque la persona dintre de l'empresa pugui utilitzar en comptes de root.

Revisar podria ser que ja existis.

## Moure els shortcuts d'usuari

Agafar els shortcuts (accions trobades a l'estrella) i moure-ls de usuari de `root` cap a l'usuari nou.

Per a aixo utilitzarem la seguent `sql` que directament mou els shortcuts de `root` al nou usuari.

```sql
BEGIN; UPDATE ir_ui_view_sc SET user_id = [id_usuari] WHERE user_id = 1;
```

En cas d'errors per duplicitat utilitzar la següent query, que nomes mou els que no son comuns:

```sql
BEGIN; UPDATE ir_ui_view_sc SET user_id = [id_usuari] WHERE user_id = 1 and id in (select
m.id 
from ir_ui_view_sc m 
left join ir_ui_view_sc c on c.action_id = m.action_id and c.res_id = m.res_id and c.action_type = m.action_type and c.view_id = m.view_id and c.user_id = [id_usuari] and m.user_id = 1 
where m.user_id = 1 and c.user_id is null);
```

## Moure els permisos i grups d'usuari

Al nou usuari per a que no perdi res, li assignarem tots els permisos de GISCE per a que pugui contrinuar treballant a mode `superuser` pero sense utiliutzar l'usuari `root`.

## Creacio usuari processos

Crearem l'usuari processos i amb la comanda `pwgen` crearem una pwd per l'user. Li assignarem el grup `` el qual li donara els permisos necessaris per executar tots els crons.

Assignar grups:

|User Groups|
|---|
| Crontab \ Cron Executor |
| Account Invoice / Manager |
| Base extended / Manager |
| BASE Index/ Manager |
| Contractacio/Manager |
| CRM / Manager |
| Custom Search / User |
| Elasticsearch Client |
| Employee |
| GISCEDATA cts / Manager |
| GISCEDATA CUPS / Manager |
| GISCEDATA facturació/ Manager |
| GISCEDATA Lectures / Manager |
| GEISCEDATA lectures telegestió / Manager |
| GISCEDATA measures / Manager |
| Giscedata Moxa / User |
| GISCEDATA perfils / Manager |
| GISCEDATA Polissa / Manager |
| GISCEDATA profiles / Manager |
| GISCEDATA PUNT FRONTERA / User |
| GISCEDATA Qualitat (Escriptura) |
| GISCEDATA RECORE / User |
| GISCEDATA telemesires base / Manager |
| GISCEDATA Tensions / User |
| GISCEGIS BASE v3 / User |
| OORQ / User |
| Partner Manager |
| Poweremail / External_users |
| Poweremail / Internal_users |
| Product / Manager |
| Project / User |
| Stock / Worker |
| Switching / User |
| Telegestio / Manager |
| Telegestio / User |

## Modificar els crons

A l'usuari erp `crontab -e` i canviar totes les mencions de l'usuari root i la seva contrasenya per el nou usuari processos i la nova contrasennya pertinent.

Es pot revisar els crons d'altres usuaris vistant la carpeta: `/var/spool/cron/crontabs`

## Configurar Openstg i Import tm

### OpenSTG

Entrarem al servidor on estigui instalat, tot sovint a una raspberry-pi i entrarem a l'usuari `stg`. Visitarem l'arxiu `~/conf/stg_uwsgi_saltoscabrera.ini` i canviarem l'usuari i la pwd.

despres reiniciarem el servei desde el supervisor.

### Configurar Telemesura (import_tm)

Sempre esta al `crontab` de l'usuari `erp` de la raspberry i/o del servidor. Canviar de root a gisce

## Configurar usuari GIS

Entrar a usuari gis carpeta `~/etc/uwsgi/webgis.ini` i canviar usuari i pwd de root a gisce

reiniciar serveis de webgis/websearch/tms amb el `supervisorctl`

## Actualitzar System Controller

Entrar a l'ERP-TI i actualitzar les credencials del servidor.

## Revisar que tot funciona
