# Reproduction evidence

Environment: isolated x86_64 Docker lab, `php:8.5.11-apache`, mod_php, one
worker, `memory_limit=16M`, `post_max_size=32M`, upload progress enabled.

## Chain A — startup OOM → stale bucket → pDestructor

- Allocator: `USE_ZEND_ALLOC=0`, `USE_TRACKED_ALLOC=1`.
- Control ladder: calibration, negative, abort control, marker.
- Gates: 20/20 true.
- Marker: `RCE_20261021T145047Z`; independent run `RCE_20261021T142123Z`.
- Verdict: `Proven RCE`.

The marker is a fixed benign token written under `/tmp` inside the disposable
container.

## Chain B — dangling reference → zif_system

- Allocator: stock Zend MM.
- Fire mode: gdb-free; two plain multipart POSTs.
- Marker: `uid=33(www-data) gid=33(www-data) groups=33(www-data)`.
- Result: `FIRE_OK`.

The harness resolves the worker’s chunk and libphp base before firing and
completes the control ladder with the marker read back from the container.

## Sanitized evidence

- [../evidence/chain-a.md](../evidence/chain-a.md)
- [../evidence/chain-b.md](../evidence/chain-b.md)
