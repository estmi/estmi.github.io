# Introducción

:::danger title
contiene datos de cliente y no se aconseja compartir
:::

En ocasiones la API del SIPS de la CNMC deja de funcionar. Para tener los datos del SIPS siempre disponibles se puede pedir la base de datos a la CNMC y cargarla en nuestro sistema. Haciendo esto conseguimos que la fuente de datos se obtenga de la base de datos cargada cuando la API no funciona.

## Configuración

La base de datos debe tener el formato estándar proporcionado por la CNMC (fichero csv con cabecera y con los datos separados por comas)

En el servidor que tenga el mongo:

Primero crear el indice de la tabla aunque esta no exista.

```Shell
$ /opt/mongodb-3.0.15/mongo
> use DB_NAME
> db.cnmc_sips.ensureIndex({'cups': 1}, {background: true})
> db.cnmc_sips_consums.ensureIndex({'cups': 1}, {background: true})
```

Después se debe descargar la herramienta de mongoimport. Segun la version de mongo, descargar uno de los siguientes ficheros:

* 3.6.23 -> https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.6.23.tgz
* 3.4.24 -> https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.24.tgz

:warning: Se debe hacer con mongoimport de la versión >= 3.4. Probado con la versión 3.6.23. 

El `mongoimport` se encuentra dentro del fichero descargado en la carpeta `/bin/`:



### Importar datos de cups

```Shell
./mongoimport -c cnmc_sips --port PORT_MONGO --host IP_MONGO -d DB_NAME --file=$FILEPATH/SIPS.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=header.csv
```

el fichero `header.csv` es el siguiente:

```plaintext
codigoEmpresaDistribuidora.string()
cups.string()
nombreEmpresaDistribuidora.string()
codigoPostalPS.string()
municipioPS.string()
codigoProvinciaPS.string()
fechaAltaSuministro.string()
codigoTarifaATREnVigor.string()
codigoTensionV.string()
potenciaMaximaBIEW.string()
potenciaMaximaAPMW.string()
codigoClasificacionPS.string()
codigoDisponibilidadICP.string()
tipoPerfilConsumo.string()
valorDerechosExtensionW.string()
valorDerechosAccesoW.string()
codigoPropiedadEquipoMedida.string()
codigoPropiedadICP.string()
potenciasContratadasEnWP1.string()
potenciasContratadasEnWP2.string()
potenciasContratadasEnWP3.string()
potenciasContratadasEnWP4.string()
potenciasContratadasEnWP5.string()
potenciasContratadasEnWP6.string()
fechaUltimoMovimientoContrato.string()
fechaUltimoCambioComercializador.string()
fechaLimiteDerechosReconocidos.string()
fechaUltimaLectura.string()
informacionImpagos.string()
importeDepositoGarantiaEuros.string()
tipoIdTitular.string()
esViviendaHabitual.string()
codigoComercializadora.string()
codigoTelegestion.string()
codigoFasesEquipoMedida.string()
codigoAutoconsumo.string()
codigoTipoContrato.string()
codigoPeriodicidadFacturacion.string()
codigoBIE.string()
fechaEmisionBIE.string()
fechaCaducidadBIE.string()
codigoAPM.string()
fechaEmisionAPM.string()
fechaCaducidadAPM.string()
relacionTransformacionIntensidad.string()
CNAE.string()
codigoModoControlPotencia.string()
potenciaCGPW.string()
codigoDHEquipoDeMedida.string()
codigoAccesibilidadContador.string()
codigoPSContratable.string()
motivoEstadoNoContratable.string()
codigoTensionMedida.string()
codigoClaseExpediente.string()
codigoMotivoExpediente.string()
codigoTipoSuministro.string()
aplicacionBonoSocial.string()

```

### Importar datos de consumos

```Shell
./mongoimport -c cnmc_sips_consums --port PORT_MONGO --host IP_MONGO -d DB_NAME --file=$FILEPATH/SIPS.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=consums.csv
```

el fichero `consums.csv` es el siguiente:

```plaintext
cups.string()
fechaInicioMesConsumo.string()
fechaFinMesConsumo.string()
codigoTarifaATR.string()
consumoEnergiaActivaEnWhP1.string()
consumoEnergiaActivaEnWhP2.string()
consumoEnergiaActivaEnWhP3.string()
consumoEnergiaActivaEnWhP4.string()
consumoEnergiaActivaEnWhP5.string()
consumoEnergiaActivaEnWhP6.string()
consumoEnergiaReactivaEnVArhP1.string()
consumoEnergiaReactivaEnVArhP2.string()
consumoEnergiaReactivaEnVArhP3.string()
consumoEnergiaReactivaEnVArhP4.string()
consumoEnergiaReactivaEnVArhP5.string()
consumoEnergiaReactivaEnVArhP6.string()
potenciaDemandadaEnWP1.string()
potenciaDemandadaEnWP2.string()
potenciaDemandadaEnWP3.string()
potenciaDemandadaEnWP4.string()
potenciaDemandadaEnWP5.string()
potenciaDemandadaEnWP6.string()
codigoDHEquipoDeMedida.string()
codigoTipoLectura.string()
```

Dependiendo de la máquina y del tamaño de la base de datos la importación puede tardar unas horas.

Ya hemos acabado!

## Una explicación mas detallada

Descargamos los 2 zips en local (no los descomprimimos)

Subimos con SCP los zips:
`scp /home/alex/descargas/202206_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular-002.zip gisce@tec.gisce.cloud:/home/gisce/`

Pasamos los archivos de home/gisce a la máquina de mongo:

`scp /202206_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular-002.zip gisce@mongo:/mnt/HC_Volume_33324861/tmp/` ← puede cambiar el nombre HC…

Vamos a carpeta temporal(donde esta mongo y los archivos):
`cd /mnt/HC_Volume_20025084/tmp`

Descomprimimos los archivos y eliminamos los zips. Dependiendo del tamaño disponible en la maquina es mejor cargar el fichero de los puntos de suministro y despues el fichero de consumos.
`unzip 202206_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular-002.zip`

Como importar el archivo en la base de datos mongo (tarda unas horas):
Debemos fijarnos en la base de datos de mongo “c” que por un archivo u otro es diferente y en el “--fieldFile” que también es diferente. Por lo que la hace ip la podemos encontrar en el conf del mongo del mismo directorio
Para importar **consumos**. Tener en cuenta que el campo -c tiene valor **cnmc_sips_consums** y el campo --fieldFile **consums.csv**:
`./mongoimport -c cnmc_sips_consums --port 27017 --host 192.168.0.3 -d tec --file=202209_SIPS2_CONSUMOS_ELECTRICIDAD_peninsular.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=consums.csv`

Para hacer los archivos de **puntos de suministro**. Tener en cuenta que el campo -c tiene valor **cnmc_sips** y el campo --fieldFile **header.csv**:
`./mongoimport -c cnmc_sips --port 27017 --host 192.168.0.6 -d tec --file=202302_SIPS2_PS_ELECTRICIDAD_peninsular.csv --type=csv --upsertFields=cups --columnsHaveTypes --fieldFile=header.csv`

Abriendo otra terminal con` df -h` podemos saber el espacio que queda mientras se va importando