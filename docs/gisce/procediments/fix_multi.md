# FIX Multi

## Acciones a realizar

1. Invalidar los perfiles, vaciar su metodo de obtencion de cch y eliminar los perfiles no brutos
2. Validar los perfiles
3. Crear lecturas
4. Fix Multi

## Invalidar los perfiles

Para invalidar los perfiles, entraremos en el contador afectado y utilizando el boton de `Curva TG` localizado en la parte inferior podremos acceder a los perfiles/la curva. Una vez alli filtraremos los datos para obtener los perfiles necesarios, por ejemplo diciembre de 2024:

![filtro_perfiles]

Con este filtro obtendremos 744 registros correspondientes a todas las horas de diciembre.

Los seleccionaremos todos y utilizaremos el asistente (boton del rayo) nomenado `Validar Perfiles`:

![perfiles_validar_wizard]

Dentro del asistente le diremos que queremos `Marcar como inválido` y luego tambien marcaremos los 2 checkboxes:

![wizard_validate_profiles]

## Validar los perfiles

Ahora mismo validaremos los perfiles que quedan, en el paso anterior los hemos invalidado y eliminado los incorrectos, ahora marcaremos como correctos los que quedan.

Para ello entraremos en el contador y utilizaremos el asistente de `Validad medidas contador` en el que le diremos `Tipo`: `Perfiles`. Si lo hacemos asi mismo, se validaran en segundo plano, esto nos va bien porque no tenemos que esperarnos pero no sabemos cuando va a acabar, depende del momento puede ser meros segundos o pueden ser horas, dependiendo de lo que este pasando en segundo plano. Para hacerlo en el mismo sitio podemos utilizar el checkbox de `Validar sincronamente`:

![wizard_validate_measures_meter]

## Crear Lecturas

En este momento hay que crear las lecturas que pertocarian en el periodo.

## Fix Multi

Para hacer un Fix Multi, utilizaremos el registrador localizado en la pestanya `General` del contador, alli seleccionaremos la pequenya fecha redonda y le daremos a `Acción` y luego a `Fix multi`.

![register_actions_from_meter]

![fix_multi_action_list]

### Rellenar los datos del fix multi

- Fechas: En el caso de ejemplo, diciembre de 2024, seran 01/12/2024 y 01/01/2025, ya que la primera se incluye y la segunda no.
- Tarifa: Indicaremos la tarifa de acceso de la poliza.
- Origen: Seleccionaremos el origen de las lecturas.
- Checkboxes: Seleccionaremos si tenemos Energia entrante, saliente y sus pertenientes reactivas.

En la parte inferior pondremos los consumos para cada periodo, teniendo en cuenta que Reactiva entrante 1 es la linia de energia reactiva y la Reactiva 4 es la linea de energia capacitiva. En el caso de las salientes tenemos la 2 que es la reactiva y la 3 que es la capacitiva.

![fix_multi_image]

![fix_multi_in_reactive]

![fix_multi_out_reactive]

[filtro_perfiles]: /gisce/procediments/fix_multi/filtro_perfiles.png
[perfiles_validar_wizard]: /gisce/procediments/fix_multi/perfiles_validar_wizard.png
[wizard_validate_profiles]: /gisce/procediments/fix_multi/wizard_validate_profiles.png
[wizard_validate_measures_meter]: /gisce/procediments/fix_multi/wizard_validate_measures_meter.png
[register_actions_from_meter]: /gisce/procediments/fix_multi/register_actions_from_meter.png
[fix_multi_action_list]: /gisce/procediments/fix_multi/fix_multi_action_list.png
[fix_multi_image]: /gisce/procediments/fix_multi/fix_multi_image.png
[fix_multi_in_reactive]: /gisce/procediments/fix_multi/fix_multi_in_reactive.png
[fix_multi_out_reactive]: /gisce/procediments/fix_multi/fix_multi_out_reactive.png
