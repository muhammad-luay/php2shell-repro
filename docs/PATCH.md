# Patch and affected versions

## Fixed releases (2026-10-21)

| Branch | Fixed release |
|---|---|
| 8.5 | **8.5.12** |
| 8.4 | **8.4.27** |
| 8.3 | **8.3.36** |
| 8.2 | **8.2.35** |

## Affected

- PHP **5.4.0 through 8.5.11**, including all older branches.
- Vulnerable if below the fixed release for its branch:
  - 8.2.x `< 8.2.35`
  - 8.3.x `< 8.3.36`
  - 8.4.x `< 8.4.27`
  - 8.5.x `< 8.5.12`
- PHP 8.1 and older are EOL; there is no normal official release path. Upgrade.
  Some minimal source backports may exist; verify with your vendor/distro.

## References

- PHP release archive:
  `https://www.php.net/archive/2026.php#2026-10-21-5`
- GHSA-w8hw-w9fx-j79w (CVE-2026-109618)
- GHSA-6wmf-4rv5-p3rp (CVE-2026-109619)
- Fix commit: `506e87fa7dcd` — “Avoid state corruption via bailout”

## Verify locally

```bash
php -v
php -r 'echo PHP_VERSION, "\n";'
./scripts/check_php.sh
```

The check is local-only. It does not probe remote hosts.
