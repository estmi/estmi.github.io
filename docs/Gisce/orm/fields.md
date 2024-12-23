# Fields ORM

## Simple

## Complex

### Many2Many

Quan fem un write de un many2many s'utilitza una nomenclatura especial:

#### Crear Objecte secundari i vincular

```python
polissa_obj = c.model('giscedata.polissa')

vals = {
    'field': [(`accio a seguir`, )]
}

```

# Values: (0, 0,  { fields })    create
#         (1, ID, { fields })    modification
#         (2, ID)                remove
#         (3, ID)                unlink
#         (4, ID)                link
#         (5, ID)                unlink all
#         (6, ?, ids)            set a list of links
