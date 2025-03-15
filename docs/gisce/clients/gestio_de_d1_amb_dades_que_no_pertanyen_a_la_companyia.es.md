# Gestión de D1 con datos que no pertenecen a ningún cliente de la compañía

## Ley de protección de datos

La ley de protección de datos nos indica que no se pueden guardar datos confidenciales de una persona sin su consentimiento en el erp.

## Error

En algunos D1-01, generalmente los de autoconsumos colectivos, donde el propietario del generador es externo a la compañía, no ha tenido ningún contrato con la compañía, nos podemos encontrar errores como este:

![imatge_activacio_d1_error]

Este error nos indica que no tenemos los datos del propietario del generador en el erp.

- Debido a la ley de protección de datos, el erp no importa los datos del generador automáticamente si el NIF/NIE del propietario del generador no están ya en el erp.

## Como procediremos

Nos tendremos que poner en contacto con el propietario del generador para poder obtener sus datos y una aceptación explícita que nos permita guardar sus datos en el erp. Una vez tengamos los datos, crearemos una nueva empresa con el NIF que nos ha dado el propietario de la instalación de generación y activaremos el D1.

## Configuraciones

Bajo la responsabilidad de la propia empresa, se puede desactivar una variable de configuración que importara de forma automática los datos del propietario del generador desde el D1, pero no se tendrá ningún tipo de consentimiento para esto y se tendría que obtener el consentimiento firmando algún documento de protección de datos con el propietario del generador.

En caso de querer desactivar la configuración, nos podéis enviar un SAC solicitando explícitamente que se quieren importar automáticamente estos datos, siempre bajo la responsabilidad del solicitante.
