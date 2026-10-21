# PHP2Shell — defensive reproduction notes

Public defensive/research notes for **CVE-2026-109618** and **CVE-2026-109619**
(“php2shell”), the two critical PHP-core issues fixed on 2026-10-21.

This repository intentionally contains **no exploit code, no offsets, no heap
layout, no leak scripts, and no live-target data**. It documents the two
engine-level RCE classes we reproduced in an isolated lab, how they fail, and
how to detect and patch them.

## Status

- Two independent engine RCE chains reproduced in an isolated PHP **8.5.11
  Apache/mod_php** lab.
- Both are **lab-assisted**, not portable or ASLR-independent.
- The full working harness is not published here. It lives with the upstream
  research package and is shared only under controlled/authorized access.

## Reproduced (sanitized)

**Chain A — startup OOM → stale bucket → `pDestructor`**
- PHP 8.5.11 Apache, tracked allocator (`USE_ZEND_ALLOC=0`,
  `USE_TRACKED_ALLOC=1`).
- All 20 control gates passed.
- Marker `RCE_20261021T145047Z` (vm1); independent marker
  `RCE_20261021T142123Z` (vm8).
- Verdict: `Proven - Lab-Assisted RCE`.

**Chain B — cross-request dangling reference → `zif_system`**
- PHP 8.5.11 Apache, stock Zend MM, gdb-free fire.
- Marker: `uid=33(www-data) gid=33(www-data) groups=33(www-data)`.
- Result: `FIRE_OK`.
- Addresses sourced from `/proc` in the lab; not ASLR-independent.

See [docs/REPRODUCTION.md](docs/REPRODUCTION.md) and
[evidence/](evidence/).

## What this is not

- Not a remote, turnkey exploit.
- Not a claim that every affected deployment is exploitable.
- Not a substitute for the official advisories.
- Not a license to test third-party systems.

## Which is more impactful?

**CVE-2026-109618** is the broader one: unauthenticated **memory disclosure**
(passwords, tokens, API keys, session data) **plus RCE**, application-agnostic,
with `session.upload_progress` default-on. **CVE-2026-109619** is also critical
but more conditional; its unique risk is cross-worker/shared-OPcache corruption
in shared or multi-tenant hosting.

## Quick local check

```bash
./scripts/check_php.sh
```

This checks only the local PHP binary/INI. It makes no network requests.

## Docs

- [Mechanisms](docs/MECHANISMS.md)
- [Detection](docs/DETECTION.md)
- [Patch and mitigation](docs/PATCH.md)
- [Reproduction evidence](docs/REPRODUCTION.md)
- [Upstream sources](docs/UPSTREAM.md)

## Responsible use

Use only on systems you own or are explicitly authorized to test. Report
issues to the PHP security team or the affected vendor; do not use this
material against third parties. See [SECURITY.md](SECURITY.md).
