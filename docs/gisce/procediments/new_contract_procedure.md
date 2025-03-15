--- 
hide_table_of_contents: false
toc_min_heading_level: 2
toc_max_heading_level: 5
---
# Procedimiento de contratacion

- [Proceso](#proceso)
- [Lead](#lead)
  - [Oferta/Oportunidad](#ofertaoportunidad)
    - [Sobre el Punto de Suministro](#sobre-el-punto-de-suministro)
    - [Sobre el Cliente](#sobre-el-cliente)
    - [Sobre el Contrato](#sobre-el-contrato)
    - [Sobre el Pago](#sobre-el-pago)
    - [SIPS](#sips)
    - [Validaciones](#validaciones)
    - [Firma](#firma)

## Proceso

El proceso que habra que seguir es:

1. Crear el lead y rellenarlo \[[Lead](#lead)\]
2. Utilizar el asistente de `Crear o renovar contratos a partir de Oferta/Oportunidad`
3. Gestionar la firma en caso de tener firma digital activada
4. Al finalizar la firma se va a crear la poliza en borrador y tambien un caso ATR con el proceso de alta seleccioando en el lead \[[Sobre el Punto de Suministro](#sobre-el-punto-de-suministro)\]
5. Ahora ya solo hace falta gestionar el caso ATR y l apoliza quedaria activada.

## Lead

Primero entraremos al listado de leads siguiendo las indicaciones en el menu \[pasos 1-3\]. Una vez en el listado, abriremos el formulario de nuevo lead \[paso 4\]:\
![tree_leads]

Una vez dentro del formulario del lead, introduciremos una descripcion en la cabecera y guardaremos:\
![form_leads_header]

Una vez hemos guardado, abriremos el lead y rellenaremos todo el lead con la info que tenemos. Durante este proceso iremos encontrando mensajes que nos iran guiando por todo el proceso hasta tener una base minima. Aunque no sean obligatorios directamente, todos los campos que tienen el simbolo `(*)` al final del nombre hay que rellenarlos siempre.

### Oferta/Oportunidad

Lo primero que veremos sera un mensaje que nos informa que no hemos especificado ningun CUPS, para resolver-lo entraremos en la pestanya `Sobre el Punto de Suministro` y en el apartado de `Datos del Punto de Suministro` le asignaremos el CUPS.

![warning_cups_not_specified]

#### Sobre el Punto de Suministro

Hay que rellenar todos los campos que vemos, entre ellos tenemos:

![form_leads_sobre_punto_suministro]

- Comercializadora
- Comercializadora actual
- Tipo de lead: Este tipo define si se esta creando una nueva poliza o renovando los precios de una
- Proceso de Activacion: Definicion de como se procede con el Alta
  - Proceso de Alta `(*)`:
    - A3: Alta nueva
    - C1: Cambio de comercializadora
    - C2: Cambio de comercializadora con cambios en la poliza
  - Configuracion
    - Cambio de tarifa/Potencia
    - Cambio de Titular
  - Firma digital: Se puede marcar para enviar un documento para que el cliente firme digitalmente via el correo electronico.
    - Forma de envio:
      - Codigo QR
      - Email
    - E-Mail Firma Digital `(*)`: Direccion donde se enviaran los documentos a firmar
    - Proveedor: Proveedor de Firma digital
  - Crear Usuario Oficina Virtual
- CUPS `(*)`
- Distribuidora: Este apartado por norma general se autorellenara con los datos ya existentes en BDD, en caso de no estar y no poder determinarlo de forma automatica, el `ERP` intentara deducir via el CUPS la distribuidora en caso de fallar, habra que hacerlo manualmente. Pongo datos de ejemplo a Endesa:
  - Codigo `(*)`: Codigo de REE, `0031`
  - Empresa `(*)`: Nombre de la distribuidora, `ENDESA DISTRIBUCION ELECTRICA, S.L.`
  - Nº de Documento `(*)`: NIF de la distribuidora, `ESB82846817`
- Direccion de suministro\
![sobre_el_punto_de_subimistro_direccion]

#### Sobre el Cliente

En este apartado rellenaremos toda una serie de datos en relacion con el titular del punto de suministro:
![form_leads_sobre_cliente]

Entre todos los datos, encontraremos el `Nombre Cliente / Razon Social (*)` donde especificaremos el nombre del cliente o empresa, tambien tenemos la `Direccion` del cliente y si fuera necesario una `Direccion de Contacto Alternativa`. En la parte superior derecha encontraremos un apartado para rellenar el email y telefono/mobil del contacto con el cliente.

#### Sobre el Contrato

En este apartado habra que determinar los datos del contrato:

![form_leads_sobre_contrato]

Y tendremos campos como:

- Datos Tecnicos
  - Tarifa ATR `(*)`: Le asignaremos la tarifa de acceso que le pertoca, ya sea 2.0TD, 3.0TD o 6.xTD
  - Tension normalizada `(*)`: Asignaremos la tension que se necesita, como las fases
  - Facturacion Potencia `(*)`:
    - Maximetro: En caso de sobrepasar la potencia contratada dependiendo del contrato se registra a cuanto se ha llegado con el pico de luz o cuanto tiempo se ha sobrepasado.
    - ICP: En caso de sobrepasar la potencia contratada se corta la luz.
    - Recargo NO_ICP
- Potencias Contratadas (kW): Aqui encontraremos los diferentes periodos de luz, aunque solo estan marcados como requeridos P1 y P2, cabe remarcar que en caso de una tarifa 3.0TD o 6.xTD hay que especificar los 6 periodos y cada periodo va a ser superior al anterior, P1 < P2 < P3 < P4 < P5 < P6.
- Tarifa de venta `(*)`: Lista de precios que se utilizara en el momento de facturar
- Datos Administrativos:
  - Suministro no cortable: Seleccionar el tipo de suministro no cortable en caso de ser necesario
  - CNAE `(*)`
  - Autoconsumo `(*)`
  - Fecha de alta prevista `(*)`
  - Cicle activacio:
    - `(A)`: La activación se debe producir cuanto antes
    - `(L)`: La activación se debe producir con próxima lectura del ciclo
    - `(F)`: La activación se producirá según la fecha fija solicitada
  - Tipo contrato `(*)`:
    - `(01)`: Anual
    - `(02)`: Eventual medido
    - `(03)`: Temporada
    - `(05)`: Suministro a instalaciones RECORE
    - `(07)`: Suministro de Obras
    - `(08)`: Suministro de Socorro
    - `(09)`: Eventual a tanto alzado
    - `(10)`: Pruebas
    - `(11)`: Duplicado
    - `(12)`: De reserva
- Condiciones del contrato: Condiciones generales asociadas al contrato.

#### Sobre el Pago

Ahora estableceremos como va a pagar el cliente:

![form_leads_sobre_pago]

- Datos de Facturacion:
  - Periodicidad facturacion `(*)`:
    - Mensual
    - Bimestral
  - Enviar factura vía `(*)`:
    - Correo Postal
    - E-mail
    - Correo postal y e-mail
- Forma de Pago
  - Grupo de pago `(*)`
  - Cuenta IBAN `(*)`

#### SIPS

Este apartado nos va a ayudar bastante ya que nos va a rellenar bastantes campos del punto de suministro e incluso del contrato como la direccion, potencias contratadas, tarifa de acceso y demas.

![form_leads_sips]

Aqui encontraremos 4 botones en la botonera de arriba a la izquierda:

- `Descargar informacion sobre el PS del SIPS`: Descargara informacion sobre el punto de suministro y la ubicara en la parte de la derecha de la pestanya
- `Descargar informacion sobre consumos del SIPS`: Descargara informacion sobre el consumo del punto de suministro y la ubicara en la parte inferior de la pestanya
- `Descargar consumos en CSV/XLS`: Nos permitira descargar un CSV o Excel con los datos de los consumos del CUPS.
- `Actualizar datos de la Oferta/Oportunidad a partir de los datos descargados del SIPS`: Cogera los datos recogidos desde el SIPS y los asignara a la oferta/lead

#### Validaciones

#### Firma

Desde este apartado podremos ver el estado de la firma:

![form_leads_firma]

- Firmat: Nos indica que el cliente ya ha firmado
- Proces Firma: Podemos ver el proceso de firma asociado
- Status Firma: Estado actual de la firma
- Fecha Firma
