# Chain A — sanitized evidence

```text
php: 8.5.11
sapi: apache2handler
allocator: USE_ZEND_ALLOC=0, USE_TRACKED_ALLOC=1
gates: 20/20 true
passed: true
verdict: Proven - Lab-Assisted RCE
marker_token: RCE_20261021T145047Z
independent_marker: RCE_20261021T142123Z
```

The run included calibration, negative, abort, and marker cases. The marker was
absent before the marker request and present after it. Addresses and slot
geometry are intentionally omitted.

Boundary: generation-calibrated execution in a dedicated tracked-allocator lab;
not a portable ASLR-independent exploit and not proof of universal PHP impact.
