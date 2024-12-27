# Com fer una migracio

## Estructura base

```python
# -*- coding: utf-8 -*-
import logging

def up(cursor, installed_version):
    if not installed_version:
        return

    logger = logging.getLogger('openerp.migration')


def down(cursor, installed_version):
    pass


migrate = up

```

## load_data_records

```python
#Importar a dalt de tot
from oopgrade.oopgrade import load_data_records

# Informar modul de treball, arxiu on esta l'id existent i quins ids volem importar
migration_filename = #Arxiu migracio
module_name = # nom modul actual
filename = # xml a actualitzar
records_ids = # [] # ids a actualitzar

logger.info('START:[{}]load_data_records'.format(migration_filename))
load_data_records(cursor, module_name, filename, records_ids, mode='update')
logger.info('END:[{}]load_data_records'.format(migration_filename))
```

## Utilitzar si la migracio es podria ometre en cas de update all

En un update all hi ha molts processos que passen, entre ells, sincronitzacio python BD, aka. _auto_init i tambe es carreguen els xmls, aka load_data.

```python
from tools import config
if config.updating_all:
    return
```

## Actualitzar ondelete de un one2many

```python
def update_contraint(cursor, constraint_name, ondelete):
    sql = """SELECT confdeltype, conname, cl1.relname as _table, att1.attname as k, cl2.relname as ref, att2.attname as id FROM pg_constraint as con, pg_class as cl1, pg_class as cl2,
    pg_attribute as att1, pg_attribute as att2
    WHERE con.conrelid = cl1.oid
    AND con.confrelid = cl2.oid
    AND array_lower(con.conkey, 1) = 1
    AND con.conkey[1] = att1.attnum
    AND att1.attrelid = cl1.oid
    AND array_lower(con.confkey, 1) = 1
    AND con.confkey[1] = att2.attnum
    AND att2.attrelid = cl2.oid
    AND con.contype = 'f' and conname = '{}'""".format(constraint_name)
    cursor.execute(sql)
    res = cursor.dictfetchall()[0]
    cursor.execute('ALTER TABLE "' + res['_table'] + '" DROP CONSTRAINT "' + res['conname'] + '"')
    cursor.execute('ALTER TABLE "' + res['_table'] + '" ADD FOREIGN KEY ("' + res['k'] + '") REFERENCES "' + res['ref'] + '" ON DELETE ' + ondelete)
```
