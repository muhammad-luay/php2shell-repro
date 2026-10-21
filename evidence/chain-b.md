# Chain B — sanitized evidence

```text
php: 8.5.11
sapi: apache2handler
allocator: stock Zend MM
fire mode: gdb-free, two plain multipart POSTs
marker: uid=33(www-data) gid=33(www-data) groups=33(www-data)
result: FIRE_OK
```

The lab resolved the worker chunk and libphp base from `/proc`; those addresses
and offsets are intentionally omitted.

Boundary: this demonstrates the dangling-reference/9bie-class chain in an
isolated lab with local `/proc` access. It is not a remote or ASLR-independent
exploit as run.
