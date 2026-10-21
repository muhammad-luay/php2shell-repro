# Upstream sources

This repository is defensive notes, not a fork of any exploit package.

## Official / primary

- Wiz Research — “PHP2Shell: AI uncovers critical RCE vulnerabilities”:
  `https://www.wiz.io/blog/php2shell-php-rce`
- PHP release archive:
  `https://www.php.net/archive/2026.php#2026-10-21-5`
- GHSA-w8hw-w9fx-j79w (CVE-2026-109618)
- GHSA-6wmf-4rv5-p3rp (CVE-2026-109619)
- Fix commit `506e87fa7dcd`
- `https://php2shell.com`

## Public labs / independent work

- `dinosn/php-cve-2026-10961x-lab-poc`
- `mnk-works/php2shell-verify`
- `santihabib/CVE-2026-109619`
- `rdwr-namikb/php2shell-cve-2026-109618-109619-lab`
- `break-the-build/php-uploadprogress-waf`
- `xuehuolll/CVE-2026-109618-109619-audit`
- `19h/CVE-2026-109618`
- `9bie/php2shell-bypass-aslr-exp`
- `ikow/php2shell-poc`
- `beescoitu` full-chain demo (video/writeup; code withheld at time of writing)

## Embargo and reuse

Some upstream packages carry explicit private/embargo terms. Do not mirror or
fork them, and do not republish their weaponized code without permission.
Link to the upstream instead.

## Mapping caveat

Public material does not fully agree on which CVE maps to which lab chain.
Treat chain names as lab labels; use the PHP advisories and Wiz writeup for
CVE-level claims.
