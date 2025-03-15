# Importar SIPS

## Descarregar SIPS

El client ens envia els zips amb tots els SIPS, els descarregarem i guardarem dins d'una carpeta.

![zips_en_carpeta]

Seran un total de 8 arxius, 4 de PS i 4 de CONSUMOS i son els seguents: ELECTRICIDAD_baleares, ELECTRICIDAD_canarias, ELECTRICIDAD_peninsular i GAS_nacional.

Depen del client potser nomes hi haura ELECTRICIDAD_peninsular.

## Preparant la importacio

### Enviar els sips al servidor

Utilitzarem la comanda `scp` per poder enviar tots els zips al servidor:

```ShellSession
localhost:~$ scp *.zip {server}:/home/gisce/sips
202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.zip                                            100%   18GB  59.4MB/s   05:12
202502_SIPS2_PS_ELECTRICIDAD_peninsular.zip                                                  100%  934MB  60.4MB/s   00:15
```

Mourem els zips a la maquina de mongo:

```ShellSession
localhost:~$ scp *.zip {server}:/home/gisce/sips
202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.zip                                            100%   18GB  59.4MB/s   05:12
202502_SIPS2_PS_ELECTRICIDAD_peninsular.zip                                                  100%  934MB  60.4MB/s   00:15
```

## Preparar zips per a la càrrega

Moure els zips a una carpeta temporal on tinguem espai i usarem unzip:

```ShellSession
localhost:~$ unzip 202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.zip
Archive:  202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.zip
  inflating: 202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.csv
localhost:~$ unzip 202502_SIPS2_PS_ELECTRICIDAD_peninsular.zip
Archive:  202502_SIPS2_PS_ELECTRICIDAD_peninsular.zip
  inflating: 202502_SIPS2_PS_ELECTRICIDAD_peninsular.csv
```

## Executar carrega

### Carrega Punts de Subministrament

```ShellSession
./mongoimport -c cnmc_sips --port 27017 --host 192.168.0.6 -d tec --file 202502_SIPS2_PS_ELECTRICIDAD_peninsular.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=header.csv
```

### Carrega Consums

```ShellSession
./mongoimport -c cnmc_sips --port 27017 --host 192.168.0.6 -d tec --file 202502_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=consums.csv
```
