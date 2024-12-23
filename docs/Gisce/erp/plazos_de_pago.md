# Creación de Plazos de Pago

- [Donde encontrar el menú](#donde-encontrar-el-menú)
- [Creando el Plazo de pago](#creando-el-plazo-de-pago)
- [Añadiendo vencimientos](#añadiendo-vencimientos)
- [Ejemplos](#ejemplos)
  - [Vencimiento a 15 días, 50 euros](#vencimiento-a-15-días-50-euros)
  - [Vencimiento a 10 días, 50 %](#vencimiento-a-10-días-50-)
  - [Vencimiento a 1 del mes después de 5 días, total factura](#vencimiento-a-1-del-mes-después-de-5-días-total-factura)
  - [Resultado del Ejemplo](#resultado-del-ejemplo)

## Donde encontrar el menú

`Contabilidad y finanzas` :arrow_right: `Configuracion` :arrow_right: `Plazos de pago`:

![menu_plazos_de_pago]

## Creando el Plazo de pago

Primero de todo crearemos un nuevo plazo de pago, le asignaremos un nombre y lo guardaremos:

![plazo_de_pago_nuevo]

También si es conveniente, podemos asignarle una descripción.

## Añadiendo vencimientos

Para añadir los vencimientos, iremos a la parte inferior, al apartado llamado `Cálculo` y añadiremos un elemento:

![vencimiento_nuevo]

Aquí rellenaremos los campos:

- `Nombre linea`: define un nombre identificativo
- `Secuencia`: define en que orden saldrán los vencimientos
- `Valor`: define como se calculara el importe del vencimiento utilizando el `Valor importe`:
  - `Porcentaje`: Se imputará el resultado de multiplicar el valor de la factura con `Valor Importe`. 1 en `Valor Importe` equivale al 100% i 0.25 equivale al 25%.
  - `Saldo pendiente`: Se imputará el total de la factura.
  - `Importe fijo`: Se imputará el valor establecido en el `Valor Importe`.
- `Valor importe`: El valor será un importe en el caso de `Importe fijo` o un valor entre 1 y 0 en el caso de `Porcentaje` siendo 1 el 100% y un número de en medio como 0.65 el 65%.
- `Numero de dias`: Valor de días al que se le sumara a la fecha de la factura.
- `Dia del mes`: Día del mes que se asignara posterior a la fecha de número de días. Si se deja a 0 se utilizará el día que se calcule en `Numero de dias`.

## Ejemplos

### Vencimiento a 15 días, 50 euros

![plazo_50e_15_dias]

### Vencimiento a 10 días, 50 %

![plazo_50p_10_dias]

### Vencimiento a 1 del mes después de 5 días, total factura

![plazo_total_dia_1_5_dias]

Será el próximo día 1 del mes, después de 5 días de la fecha de cálculo.

### Resultado del Ejemplo

![plazo_de_pago_configurado]

Con el plazo de pago configurado obtendríamos este resultado:

- Al cabo de 15 días haber pagado 50 euros
- Diez días después hay que pagar el 50% restante
- Y el siguiente día 1 del mes, después de 5 días del vencimiento anterior, el resto de la factura.

[menu_plazos_de_pago]: /plazos_de_pago/menu_plazos_de_pago.png
[plazo_de_pago_nuevo]: /plazos_de_pago/plazo_de_pago_nuevo.png
[vencimiento_nuevo]: /plazos_de_pago/vencimiento_nuevo.png
[plazo_50e_15_dias]: /plazos_de_pago/plazo_50e_15_dias.png
[plazo_50p_10_dias]: /plazos_de_pago/plazo_50p_10_dias.png
[plazo_total_dia_1_5_dias]: /plazos_de_pago/plazo_total_dia_1_5_dias.png
[plazo_de_pago_configurado]: /plazos_de_pago/plazo_de_pago_configurado.png
