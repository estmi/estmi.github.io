# keepup manual

```bash
PATH=/home/erp/bin:/usr/bin:/bin ~/bin/keepupd --config=/home/erp/conf/{conf-empresa} update

git fetch --prune
git merge origin/v24.5-minors
# Resolve conflicts if any
git add {files with conflicts}
git commit
```

En cas de no reiniciar automaticament, fer:

```bash
PATH=/home/erp/bin:/usr/bin:/bin ~/bin/keepupd --config=/home/erp/conf/{conf-empresa} update --force
```