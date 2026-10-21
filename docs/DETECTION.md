# Detection and hardening

## Network signals

- Multipart `POST` containing `PHP_SESSION_UPLOAD_PROGRESS`, especially with
  `PHPSESSID` in the body rather than a cookie.
- Very large field values or filenames, deliberate slow uploads/stalls, and
  repeated requests that end in memory-limit errors or HTTP 500.
- A `PHPSESSID` response cookie that is unexpectedly large or malformed, or
  that appears on a request that never called `session_start()`.
- Worker churn: repeated child exits, `zend_mm_heap corrupted`, or pool
  exhaustion shortly after multipart traffic.

## Content-Type parser differential

PHP's SAPI layer trims the `Content-Type` value at `;`, `,`, and space before
selecting the multipart handler, while several WAF/IDS signatures only match
the canonical `multipart/form-data; boundary=` form. All of these are parsed as
multipart in the lab:

```text
multipart/form-data; boundary=X
multipart/form-data, boundary=X
multipart/form-data boundary=X
multipart/form-data , boundary=X
multipart/form-data;boundary=X
```

WAF guidance: normalize/parse `Content-Type` before matching; match the
upload-progress field name independently of the header separator; alert on
body-supplied `PHPSESSID`; rate-limit large multipart bodies and repeated OOM
responses.

## Host signals

- PHP version below the fixed release for the branch.
- `session.upload_progress.enabled=1` where it is not required.
- OOM/fatal errors in `Unknown on line 0` (startup-time, no script frame).
- `sess_*` files containing `upload_progress_` keys, or unexpected session
  files for IDs supplied only in POST bodies.
- OPcache shared-state anomalies, cross-worker crashes, or restarts after
  fatal errors.
- `display_errors` enabled in production; verbose startup diagnostics.

## Controls

- Patch to **8.5.12 / 8.4.27 / 8.3.36 / 8.2.35** or later. This is the only
  complete remediation.
- `session.upload_progress.enabled=0` removes the upload-progress surface for
  the 109618 paths, but is **not** a complete mitigation for every 109619
  variant.
- Keep `opcache` patched and monitor shared-state health; do not disable it as
  a substitute for patching.
- Avoid `display_errors` in production.
- Isolate PHP workers/pools between tenants where practical.
- Do not actively scan third-party systems; these signals are for your own
  logs and assets.
