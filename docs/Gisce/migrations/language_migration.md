# Language Migration

## Crear Migracio

Per fer la migracio, hi ha varies parts, pero la primera sempre es igual:

```python
# -*- coding: utf-8 -*-
import logging


def up(cursor, installed_version):
    if not installed_version:
        return

    logger = logging.getLogger('openerp.migration')
    uid = 1
    module_name = 'giscedata_crm_leads'


def down(cursor, installed_version):
    pass


migrate = up

```

## Models amb columns i constraints modificats

En cas de canviar coses dels columns o constraints, necessitarem fer un `_auto_init`.
Per a fer un `_auto_init` utilitzarem aquest patro:

- [Primer obtindrem el pool](#obtenir-pool)

- Dintre de `def up(cursor, installed_version):`

    ```python
        # Aqui definirem els models modificats que necessiten l'_auto_init
        models_to_auto_init =[
            'giscedata.crm.lead',
        ]
        for model in models_to_auto_init:
            pool.get(model)._auto_init(cursor, context={'module': module_name})
    ```

## Camps simples dintre de XMLs

Primer farem una llista de diccionaris que contindran la `id` establerta a l'xml, un `old_val` que contindra el valor actual a l'xml, un `new_val` que sera el valor que li assignarem a partir d'ara i el `field` que ens indica quin field s'esta modificant (majoritariament el `name`)

```python
    records = [
        {'id': 'crm_case_section_crm_leads', 'old_val': 'Ofertes/Oportunitats', 'new_val': 'Ofertas/Oportunidades', 'field': 'name'},
        {'id': 'validar_potencia_contractada_alta_polissa_desde_c1_lead', 'old_val': 'Validar potencia contractada al crear una polissa desde un lead de tipus C1', 'new_val': 'Validar potencia contratada al crear una póliza desde un lead de tipo C1', 'field': 'description'},
    ]
```

Un cop tenim el diccionari, utilitzarem aquest codi, per a carregar-ho a la BD:

- [Obtenir pool](#obtenir-pool)

```python
    imd_obj = pool.get('ir.model.data')
    done_records = []
    for record in records:
        try:
            xml_id = record['id']

            model, table_id = imd_obj.get_object_reference(cursor, uid, module_name, xml_id)

            model_obj = pool.get(model)
            old_vals = model_obj.read(cursor, uid, table_id, [record['field']])

            if old_vals:
                if old_vals[record['field']] == record['old_val']:
                    logger.info(
                        '[post-0001_unify_lang_to_base_lang] Updating {field} on {model} '
                        'where id = {id} xml_id = {xml_id}: "{old_val}" -> "{new_val}"'
                        .format(
                            field=record['field'],
                            model=model,
                            old_val=record['old_val'],
                            new_val=record['new_val'],
                            id=table_id,
                            xml_id=xml_id))
                    model_obj.write(cursor, uid, table_id, {record['field']: record['new_val']})
                    done_records.append(xml_id)
        except:
            pass
    if len(records) != len(done_records):
        logger.error("Hi ha ids que no s'han actualitzat")
        for record in records:
            if record['id'] not in done_records:
                logger.error(record['id'])
```

Aquest metode el que fara sera carregar les modificacions, nomes en el cas que a la BD hi hagi el valor antic. En cas de no trobar-lo, l'apunta i l'informa al final via consola.

## Carregar forms i trees

Per a carregar els forms, utilitzarem el seguent metode, que simplement fa un `load_data_records` de tots els ids informats. Per informar-ho, s'ha de fer una llista de diccionaris que tindra les seguents claus:

- `filename`: Arxiu xml que s'ha modificat
- `records`: Llistat de `ids` a actualitzar

```python
    files_and_records_to_load = [
        {
            'filename': 'giscedata_crm_lead_view.xml',
            'records': [
                'giscedata_crm_leads_view_form',
                'giscedata_crm_leads_view_form_v2',
                'giscedata_crm_leads_view_tree',
                'view_crm_stage_validation_template_form',
            ]
        },
    ]
```

Un cop tenim el diccionari fet, importarem el seguent modul i executarem aquest codi per a carregar els ids.

```python
from oopgrade.oopgrade import load_data_records
```

```python
    for file_to_load in files_and_records_to_load:
        logger.info("[{filename}]Update XMLs.".format(filename=file_to_load['filename']))
        load_data_records(
            cursor, module_name, file_to_load['filename'], file_to_load['records'], mode="update"
        )
        logger.info("[{filename}]XMLs succesfully updated.".format(filename=file_to_load['filename']))
```

## Obtenir pool

```python
import pooler
pool = pooler.get_pool(cursor.dbname)
```
