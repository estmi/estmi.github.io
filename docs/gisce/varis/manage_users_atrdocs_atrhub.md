# Manage Users in ATR Hub and ATR Docs

## Crear comercialitzadora a distribuidora (atrhub)

```shell
gisce@guixes-comer-erp:~$ sudo su - root
root@guixes-comer-erp:~$ cd /home/atrhub/src/atrhub/bin
root@guixes-comer-erp:~$ ./create_ftp_user.sh {code REE}
```


## Crear distribuidora a comercialitzadora (atrdocs)

Check that user doesn't exist in `/etc/nginx/security/.atrdocs.htpasswd`. To generate user, we need a new password, (`pwgen`) and to create the user we'll use `htpasswd`

```bash
REM GEnerate a bunch of passwd
pwgen 8
htpasswd -b /etc/nginx/security/.atrdocs.htpasswd {REE Code} {passwd}
```

Enter to url [{docs_atr_url}/docs.hola.txt]({docs_atr_url}/docs.hola.txt) to test user, use {REE_code} as user and {passwd}

Check in `/etc/nginx/security/.atrdocs.htpasswd` that user exists.
