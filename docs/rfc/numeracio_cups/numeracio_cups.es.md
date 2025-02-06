# Numeracion de CUPS

## Cuando se calculara

Nomes es calculara en el cas de marcar la opcio de `Auto numeracio` al crear el cups:

![new_cups]

## Configuracio

Per definir com obtindrem de forma automatica el numero de CUPS, s'utilitza una variable de configuracio. La variable en questio es `cups_from_seq`.

### Valors

#### Valor: 0

En cas d'assignar un `0` a la variable, es buscara el numero de cups mes gran, i s'agafara el seguent.

S'utilitza la seguent query on agafem nomes la part numerica dels cups per poder obtenir el mes gran i sumar-li 1:

```sql
select (max(substring(name, 7, 12))::bigint)+1
from giscedata_cups_ps
where substring(name, 7, 12) similar to '[0-9]+'
```

#### Valor: 1

En cas d'assignar un `1` a la variable, s'agafara el valor que ens retorni la sequencia amb codi `Numeració CUPS` (codi intern `giscedata.cups.ps`).

Aquesta sequencia esta disponible dintre del modul de `giscedata_cups_distri`:

![sequencia]

[sequencia]: /rfc/numeracio_cups/sequencia.png
[new_cups]: /rfc/numeracio_cups/new_cups.png
