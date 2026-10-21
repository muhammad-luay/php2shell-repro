# Mechanisms

The public record groups four bugs under two CVEs. The lab chains in this
repository are two engine-level RCE demonstrations; they are **not** a complete
map of every variant.

## CVE-2026-109618 — upload-progress unserializer UAF + memory disclosure

The Session module decodes session data during upload-progress handling in the
pre-initialization window. The decoder stores request-owned bookkeeping in
`BG(unserialize)`. A fatal allocation failure interrupts the path, the request
heap is destroyed, and the unserializer global state is left published. On a
later request the same worker can consume attacker-reclaimed memory as live
unserializer bookkeeping.

Separately, RFC1867 multipart parsing happens before normal module
initialization. Session upload-progress handling can publish `PS(id)`. An OOM
aborts the request before cleanup, leaving `PS(id)` pointing at freed request
memory. A later multipart request can reach the upload-progress cleanup path
before normal Session initialization resets it; PHP trusts the stale pointer
and length as a live `zend_string` and URL-encodes the reclaimed heap contents
into a `PHPSESSID` response cookie. This works without the application calling
`session_start()`.

Impact: unauthenticated worker-memory disclosure plus a memory-corruption
primitive that can be developed into RCE.

## CVE-2026-109619 — fatal-error backtrace UAF + OPcache type confusion

PHP retains the backtrace of the most recent fatal error in
`EG(last_fatal_error_backtrace)`. A fatal OOM can destroy the request heap
without undefining that executor-global value. The worker survives with a
global that still points into the previous request. A diagnostic early in the
next request can access the pointer before the executor reinitializes it; PHP
then destroys or updates the dangling backtrace and follows attacker-reclaimed
memory.

The second variant is cross-worker: during `zend_accel_script_persist()`, PHP
advances the process-local `CG(map_ptr_last)` frontier and publishes the shared
frontier only after persistence completes. An allocation failure between those
events leaves partially persisted objects referring to slots the shared state
still considers available. Another worker can reuse a slot for a different
runtime object; stale shared metadata resolves to a pointer of the wrong type,
corrupting shared OPcache state.

Impact: cross-request and cross-worker memory corruption, with RCE
demonstrated against Drupal and WordPress.

## The two lab chains

**Chain A — startup OOM → stale HashTable bucket.** A crafted multipart request
OOMs during request startup. Shutdown consumes a stale bucket as a fake zval,
reaches a controlled `pDestructor`, and executes a fixed benign marker. In the
lab this used the non-default tracked allocator and build-specific debugger
calibration.

**Chain B — dangling `PS(http_session_vars)` reference.** A pre-RINIT OOM
leaves `PS(http_session_vars)` holding a dangling `zend_reference`; a later
request reclaims the block with a live field value, routes destruction through
`zend_hash_destroy`'s `pDestructor`, and reaches `zif_system`. This is the
public 9bie-class port; the lab used stock Zend MM, but sourced addresses from
`/proc`.

## Mapping caveat

The community reproduction package maps Chain A to CVE-2026-109618 and Chain B
to CVE-2026-109619. The Wiz writeup describes 109618 as the upload-progress
unserializer UAF plus memory disclosure, and 109619 as the fatal-error
backtrace UAF plus OPcache type confusion. The CVE-to-chain assignment is not
fully settled in public material. Treat “Chain A/B” as lab names, not as
authoritative CVE labels.

## Why 109618 is broader

109618 combines **data theft without RCE** (worker memory via `PHPSESSID`) with
RCE, is application-agnostic, and relies on a default-on feature. 109619 is
also critical but needs more specific conditions; its shared-OPcache variant is
especially relevant to shared and multi-tenant hosting.
