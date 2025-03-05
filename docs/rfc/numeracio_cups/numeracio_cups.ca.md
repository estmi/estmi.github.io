# Numeració de CUPS

## Quan es calcularà

Només es calcularà en el cas de marcar l'opció de `Auto numeracio` en crear el cups:

![new_cups]

## Configuració

Per definir com obtindrem de forma automàtica el número de CUPS, s'utilitza una variable de configuració. La variable en qüestió és `cups_from_seq`.

### Valors

#### Valor: 0

En cas d'assignar un `0` a la variable, es buscarà el nombre de cups més gran, i s'agafarà el següent.

S'utilitza la següent query on agafem només la part numèrica dels cups per poder obtenir el més gran i sumar-li 1:

```sql
select (max(substring(name, 7, 12))::bigint)+1
from giscedata_cups_ps
where substring(name, 7, 12) similar to '[0-9]+'
```

#### Valor: 1

En cas d'assignar un `1` a la variable, s'agafarà el valor que ens retorni la seqüència amb codi `Numeració CUPS` (codi intern `giscedata.cups.ps`).

Aquesta seqüència està disponible dintre del mòdul de `giscedata_cups_distri`:

![sequencia]

[sequencia]: /rfc/numeracio_cups/sequencia.png
[new_cups]: /rfc/numeracio_cups/new_cups.png
