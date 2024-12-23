# Utilitzacio basica de ORM

- [Obtenir el pool](#obtenir-el-pool)
  - [ERP](#erp)
  - [iPython](#ipython)
- [Llegir dades (read)](#llegir-dades-read)
  - [Parametres](#parametres)
  - [Retorn](#retorn)
  - [Exemple](#exemple)
- [Escriure dades (write)](#escriure-dades-write)
  - [Parametres](#parametres-1)
  - [Retorn](#retorn-1)
  - [Exemple](#exemple-1)

## Obtenir el pool

Per a obtenir el pool d'un objecte, es fara de dos maneres diferents, depenent de si estem a l'erp o a ipython.

Posarem l'exemple de l'objecte `giscedata.polissa`:

### ERP

```python
pol_obj = self.pool.get('giscedata.polissa')
```

### iPython

```python
pol_obj = c.model('giscedata.polissa')
```

## Llegir dades (read)

Per llegir dades utilitzarem el mètode `read()`, el qual reb varis parametres.

### Parametres

- cursor: Cursor per llegir
- uid: Id de l'usuari que llegeix
- id/ids: Un id o varis dintre d'una llista
- fields: Quines columnes volem llegir

### Retorn

El retorn dependra de si li donem una id o varies ids, en cas de donar-li una sola id, ens retornara un diccionari amb els camps solicitats i id, sempre retornara el camp id. En cas de donar-li una llista de ids, rebrem una llista plena de diccionaris, un per cada id.

### Exemple

```python
pol_obj.read(cursor, uid, 150, ["cups"])
# -> {'cups': [154, 'ES0031408260002001FA0F'], 'id': 150}
pol_obj.read(cursor, uid, [150, 160], ["cups"])
# -> [
# ->   {'cups': [154, 'ES0031408260002001FA0F'], 'id': 150},
# ->   {'cups': [165, 'ES0031408248775014YY0F'], 'id': 160}
# -> ]
```

## Escriure dades (write)

Per escriure dades utilitzarem el metode `write()`, el qual reb varis parametres.

### Parametres

- 5

### Retorn

### Exemple

```python
pol_obj.write(cursor, uid, pol_id, {'alias': '(Test Alias)'})
```
