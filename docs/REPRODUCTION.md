# Reproduction evidence

Environment: isolated x86_64 Docker lab, `php:8.5.11-apache`, mod_php, one
worker, `memory_limit=16M`, `post_max_size=32M`, upload progress enabled.

## Chain A — startup OOM → stale bucket → pDestructor

- Allocator: `USE_ZEND_ALLOC=0`, `USE_TRACKED_ALLOC=1`.
- Control ladder: calibration, negative, abort control, marker.
- Gates: 20/20 true.
- Marker: `RCE_20261021T145047Z` (vm1); independent run
  `RCE_20261021T142123Z` (vm8).
- Verdict: `Proven - Lab-Assisted RCE`.

The marker is a fixed benign token written under `/tmp` inside the disposable
container. No addresses are included here.

## Chain B — dangling reference → zif_system

- Allocator: stock Zend MM.
- Fire mode: gdb-free; two plain multipart POSTs.
- Marker: `uid=33(www-data) gid=33(www-data) groups=33(www-data)`.
- Result: `FIRE_OK`.

The lab resolved the worker's chunk and libphp base from `/proc`; the chain is
not ASLR-independent and is not a remote exploit as run.

## Boundary

Both results are **lab-assisted**:

- Chain A required the non-default tracked allocator, `--pid=host` for host
  gdb, and build-specific slot calibration.
- Chain B required local `/proc` access to resolve addresses.
- Neither proves portable exploitation of an arbitrary deployment.

The full weaponized harness is not part of this public repository. See
[UPSTREAM.md](UPSTREAM.md); upstream packages may carry their own embargo or
usage terms.

## Sanitized evidence

- [../evidence/chain-a.md](../evidence/chain-a.md)
- [../evidence/chain-b.md](../evidence/chain-b.md)
