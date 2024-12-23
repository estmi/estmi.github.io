# Importar SIPS

## Descarregar SIPS

El client ens envia els zips amb tots els SIPS, els descarregarem i guardarem dins d'una carpeta.

![zips_en_carpeta]

Seran un total de 8 arxius, 4 de PS i 4 de CONSUMOS i son els seguents: ELECTRICIDAD_baleares, ELECTRICIDAD_canarias, ELECTRICIDAD_peninsular i GAS_nacional.

## Preparant la importacio

### Eliminar consums de sips previs

Entrarem al servidor on hem de carregar els SIPS i anirem al mongo, on eliminarem totes les dades de consums, ja que son innecessaries perque s'importen tots els consums:

```ShellSession
localhost:~$ ssh gisce@{server-client-erp}
gisce@{server-client-erp}:~$ ssh {server-client-mongo}
gisce@{server-client-mongo}:~$ mongo
MongoDB shell version v3.6.8
connecting to: mongodb://127.0.0.1:27017
WARNING: No implicit session: Logical Sessions are only supported on server versions 3.6 and greater.
Implicit session: dummy session
MongoDB server version: 3.2.22
WARNING: shell and server versions do not match
replicaops:PRIMARY> use {mongo-db}
switched to db {mongo-db}
replicaops:PRIMARY> db.cnmc_sips_consums.deleteMany({})
{ "acknowledged" : true, "deletedCount" : 99999 }
replicaops:PRIMARY> db.cnmc_sips_consums_gas.deleteMany({})
{ "acknowledged" : true, "deletedCount" : 99999 }
```

### Enviar els sips al servidor

Utilitzarem la comanda `scp` per poder enviar tots els zips al servidor:

```ShellSession
localhost:~$ scp *.zip {server}:/home/gisce/sips
202411_SIPS2_CONSUMOS_ELECTRICIDAD_baleares.zip                                                             100%  509MB  59.1MB/s   00:08    
202411_SIPS2_CONSUMOS_ELECTRICIDAD_canarias.zip                                                             100%  831MB  60.1MB/s   00:13
202411_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.zip                                                           100%   18GB  59.4MB/s   05:12    
202411_SIPS2_CONSUMOS_GAS_nacional.zip                                                                      100% 1191MB  60.5MB/s   00:19    
202411_SIPS2_PS_ELECTRICIDAD_baleares.zip                                                                   100%   31MB  58.4MB/s   00:00    
202411_SIPS2_PS_ELECTRICIDAD_canarias.zip                                                                   100%   48MB  59.4MB/s   00:00    
202411_SIPS2_PS_ELECTRICIDAD_peninsular.zip                                                                 100%  934MB  60.4MB/s   00:15    
202411_SIPS2_PS_GAS_nacional.zip                                                                            100%  438MB  59.5MB/s   00:07    
```

Mourem els zips de l'usuari gisce a la carpeta `/home/erp/var/import_sips`:

```ShellSession
gisce@{server-client-erp}:~/sips$ sudo mv * /home/erp/var/import_sips
gisce@{server-client-erp}:~/sips$ sudo chown erp:erp /home/erp/var/import_sips/*
```

### Executarem un script per poder descomprimir els zips

Executarem el seguent script desde la carpeta `/home/erp/var/import_sips` que ens descomprimira els zips i encuara la carrega de sips. Quan creem l'script de python, molt important s'ha de configurar les variables URL,DB,USER,PWD.

```bash
#! /bin/bash

mkdir 'splitted'
mkdir 'splitted/done'

for file in *.zip
do
        filename=$(echo $file | rev | cut -f 2- -d '.' | rev)
        echo "${filename}"
        zcat $file | split --additional-suffix=.csv -l 1000000 - "splitted/${filename}_splitted"
done

python queue_sips.py
```

`queue_sips.py`:

```python
# -*- encoding: utf-8 -*-
from erppeek import Client
from os import environ

from pathlib import Path

server = # url erp
db = # nom database
user = # usuari a utilitzar
password = # password
folder_path = str(Path().resolve())+'/splitted'

if not server or not db or not user or not password or not folder_path:
   raise Exception('Falta alguna variable, URL o DB o USER o PASSWORD o PATH')

c = Client(server, db, user=user, password=password)

c.GiscedataCnmcComerSipsImporter.process_dir(folder_path)
```

[zips_en_carpeta]:/import_sips/image.png
