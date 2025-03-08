# Traduccio d'un modul

- [Traduir .py](#traduir-py)
- [Traduir XML](#traduir-xml)
- [Migration](#migration)
- [Get POT](#get-pot)
- [Transifex](#transifex)
- [GET PO](#get-po)
- [Update Migration](#update-migration)
- [Run scripts](#run-scripts)
- [Arreglar tests](#arreglar-tests)

## Traduir .py

Primerament traduirem tots els arxius python del mòdul.\
**Tenir en compte no modificar les keys dels strings, ja que sinó el format no podrà fer l'associació**

## Traduir XML

En aquest punt traduirem tots els xml, tot el que sigui text.\
**Tenir en compte que les vistes heredades busquen per aquests noms i poden petar.**\
**Tenir en compte no canviar els noms dels camps, ja que sinó no trobarà el field en el model**

## Migration

[Crear migracio PR idiomes][Migracio]

## Get POT

Per obtenir l'idioma original, farem el seguent substituint `$module_name$` pel nom del modul a traduir:

- Arrancar un destral amb els parametres: `--no-dropdb -m $module_name$ -t OOBaseTests.test_translate_modules`
- Arrancar openerp-server amb la base de dades recent instalada i obrir webclient
- Instal·lar idiomes, tant l'original (`$base_lang$`) com el que s'ha de traduir (`$translated_lang$`). [Instal·lar Idiomes]
- Exportar `.pot` amb l'[Assistent d'exportar idiomes]

Tambe es pot consultar l'[rfc transifex]

## Transifex

Per a poder fer la traducció utilitzarem un servei anomenat Transifex i aquests son els passos:

- Situarem el `.pot` descarregat a la carpeta `$module_name$/i18n` del modul indicat\
    ![pycharm_pot_file_location]
- Un cop ubicat al seu lloc (podria ser que haguéssim de crear la carpeta `i18n`) anirem a l'arxiu `erp/.tx/config` i alla buscarem el nostre mòdul, per exemple:

    ```txt
    [erp.giscedata_facturacio_comparador]
    source_file = addons/gisce/GISCEMaster/giscedata_facturacio_comparador/i18n/giscedata_facturacio_comparador.pot
    type = PO
    file_filter = addons/gisce/GISCEMaster/giscedata_facturacio_comparador/i18n/<lang>.po
    source_lang = es_ES
    ```

    Aquest bloc esta composat per la seguent estructura:

    ```txt
    [$repo_name$.$module_name$]
    source_file = $ubicacio_pot$
    type = PO # Sempre Igual
    file_filter = $ruta_carpeta_i18n_mes_`<lang>.po`$
    source_lang = $idioma_base_utilitzat_per_programar$
    ```

- Ara utilitzarem una comanda per a poder pujar el `.pot` al transifex: `tx push -r erp.$module_name$ -s`\
    ![bash_tx_push_execution]
- Un cop pujat al transifex, entrarem a la web [https://trad.gisce.net](https://trad.gisce.net), farem login i anirem a resources. Alla veurem tots els moduls traduits, el que farem sera obrir el nostre modul i obrir la traduccio a fer, per exemple el catala en aquest cas. I alla ens surtiran tots els termes per a poder traduirlos.\
    **Important marcar el check de reviewed!!**

## GET PO

Per poder obtenir el `.po`, arxiu que conte tots els termes traduits, entrarem dintre del modul, a l'idioma que volguem descarregar i donarem a la opcio de `Download for use`:

![transifex_module_view]
![transifex_module_view_language]

Aixo ens descarregara un arxiu `.po` el qual renombrarem a `ca_ES.po`, aquest nom dependra de l'idioma de traduccio i el posarem a la carpeta `i18n` del modul:

![pycharm_po_file_location]

## Update Migration

Ara que ja tenim el `.po` creat, necessitem carregar-lo, i aixo ho farem amb la migracio, que hi afegirem el seguent al final del metode up:

```python
lang = 'ca_ES'
trans_load(cursor, '{}/{}/i18n/{}.po'.format(config['addons_path'], module_name, lang), lang)
```

Per a executar aixo, necessitarem import el seguent:

```python
from tools import config
from tools.translate import trans_load
```

## Run scripts

Ara nomes falta provar-ho en local i despres a PRE. Son PRs lentes de aplicar ja que hi pot haver varis conflictes.

## Arreglar tests

Es molt possible si es toquen missatges de errors que 'petin' els tests fets en aquest modul, caldra revisar-ho.

[Migracio]: /docs/gisce/migrations/language_migration.md
[Instal·lar Idiomes]: /gisce/procediments/install_language.md
[Assistent d'exportar idiomes]: /gisce/procediments/export_language.md#us-en-cas-dexportacio-pot-per-a-transifex
[rfc transifex]: https://rfc.gisce.net/t/traducciones-procedimiento-para-traducir-un-modulo/392
[pycharm_pot_file_location]: /gisce/procediments/translate_module/pycharm_pot_file_location.png
[bash_tx_push_execution]: /gisce/procediments/translate_module/bash_tx_push_execution.png
[transifex_module_view]: /gisce/procediments/translate_module/transifex_module_view.png
[transifex_module_view_language]: /gisce/procediments/translate_module/transifex_module_view_language.png
[pycharm_po_file_location]: /gisce/procediments/translate_module/pycharm_po_file_location.png
