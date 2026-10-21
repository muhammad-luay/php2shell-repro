# Chain B — sanitized evidence

```text
php: 8.5.11
sapi: apache2handler
allocator: stock Zend MM
fire mode: gdb-free, two plain multipart POSTs
marker: uid=33(www-data) gid=33(www-data) groups=33(www-data)
result: FIRE_OK
```

The marker was read back from the disposable container after the fire request.
