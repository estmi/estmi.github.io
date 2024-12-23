# Arrancar port a part

- [Erp GTK](#erp-gtk)
- [Webclient](#webclient)
- [PUDB](#pudb)
- [Run Scripts](#run-scripts)

## Erp GTK

```bash
emiquel=1 DEBUG_ENABLED=True python /home/erp/src/erp/server/bin/openerp-server.py --no-netrpc --price_accuracy=6 --config=/home/erp/conf/$conf_file$.conf --port 12000 --interface 0.0.0.0
```

## Webclient

```bash
emiquel=1 OPENERP_MSGPACK=1 OPENERP_MSGPACK_PORT=12001 OPENERP_MSGPACK_HOST=0.0.0.0 DEBUG_ENABLED=True python /home/erp/src/erp/server/bin/openerp-server.py --no-netrpc --price_accuracy=6 --config /home/erp/conf/$conf_file$.conf --port 12000 --interface 0.0.0.0
```

## PUDB

```python
        import os
        if os.environ.get('emiquel'):
            import pudb
            pu.db
```

## Run Scripts

```python
python /home/erp/src/erp/server/bin/openerp-server.py --no-netrpc --price_accuracy=6 --config=/home/erp/conf/$conf_file$.conf --port 12000 --interface 0.0.0.0 --run-scripts=$modul$ --run-scripts-interactive
```
