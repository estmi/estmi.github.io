# Numeración de CUPS

[Article en català](numeracio_cups.ca.md)

## Cuando se calcularà

Solo se calculara en el caso de marcar la opcion de `Auto numeracion` al crear un cups nuevo:

![new_cups]

## Configuración

Para definir como obtendremos de forma automatica el numero de CUPS, se utiliza una variable de configuracion. La variable se llama `cups_from_seq`.

### Valores

#### Valor: 0

En caso de asignar un `0` a la variable, se buscara el numero de cups mas elevado y se tomara el siguiente.

Se utiliza la siguiente consulta sql donde nos quedamos con la parte numerica del cups para poder obtener el mas grande y sumarle 1:

```sql
select (max(substring(name, 7, 12))::bigint)+1
from giscedata_cups_ps
where substring(name, 7, 12) similar to '[0-9]+'
```

#### Valor: 1

En caso de asignar `1` a la variable, se tomara el valor que devuelva la secuencia con codigo `Numeració CUPS` (codigo interno: `giscedata.cups.ps`).

Esta secuencia esta disponible dentro del modulo de `giscedata_cups_distri`:

![sequencia]
