# Creación de Plazos de Pago

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

- `Valor`: En este apartado podemos escoger una de las siguientes opciones (`Porcentaje`, `Saldo pendiente` e `Importe fijo`), para definir como se calculara el importe del vencimiento
  
- `Valor importe`: En este campo el valor se tratará diferente según lo que se haya seleccionado en el campo `valor`.
  - Si se ha seleccionado la opción `Porcentaje` el valor será entre 1 y 0 siendo 1 el 100%
  - Si se ha seleccionado la opción `Saldo pendiente` el valor será el total de la factura
  - Si se ha seleccionado la opción `Importe fijo` el valor será un importe

- `Numero de dias`: En este campo se tiene que informar de los dias que se sumaran.

   > :warning: La fecha resultante se verá afectada según como se configure el campo `Dia del mes`  :warning:

- `Dia del mes`: En este campo se tiene que configurar los días que se sumaran  al cálculo realizado en el campo `Numero de dias`
  - Si se informa de un `numero negativo` el número de días empezará a partir del último día del mes actual
  - Si se informa de un valor positivo se estará informando del próximo día del mes
  - Si se informa `0` se estará indicando que este campo no tiene validez

## Ejemplos

### Vencimiento a 15 días, 50 euros

![plazo_50e_15_dias]

### Vencimiento a 10 días, 50 %

![plazo_50p_10_dias]

### Vencimiento a 1 del mes después de 5 días, total factura

![plazo_total_dia_1_5_dias]

Será el próximo día 1 del mes si el cálculo de la fecha no supera lo configurado en el campo

### Resultado del Ejemplo

![plazo_de_pago_configurado]

Con el plazo de pago configurado obtendríamos este resultado:

- Al cabo de 15 días haber pagado 50 euros
- Diez días después hay que pagar el 50% restante
- Y el siguiente día 1 del mes, después de 5 días del vencimiento anterior, el resto de la factura.

[menu_plazos_de_pago]: /gisce_data/erp/plazos_de_pago/menu_plazos_de_pago.png
[plazo_de_pago_nuevo]: /gisce_data/erp/plazos_de_pago/plazo_de_pago_nuevo.png
[vencimiento_nuevo]: /gisce_data/erp/plazos_de_pago/vencimiento_nuevo.png
[plazo_50e_15_dias]: /gisce_data/erp/plazos_de_pago/plazo_50e_15_dias.png
[plazo_50p_10_dias]: /gisce_data/erp/plazos_de_pago/plazo_50p_10_dias.png
[plazo_total_dia_1_5_dias]: /gisce_data/erp/plazos_de_pago/plazo_total_dia_1_5_dias.png
[plazo_de_pago_configurado]: /gisce_data/erp/plazos_de_pago/plazo_de_pago_configurado.png
