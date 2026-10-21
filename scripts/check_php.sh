#!/usr/bin/env bash
set -eu

command -v php >/dev/null 2>&1 || { echo "php not found"; exit 1; }

php -r 'printf("php=%s\n", PHP_VERSION);'
php -r 'printf("sapi=%s\n", PHP_SAPI);'
php -r 'printf("session.upload_progress.enabled=%s\n", ini_get("session.upload_progress.enabled"));'
php -r 'printf("session.upload_progress.cleanup=%s\n", ini_get("session.upload_progress.cleanup"));'
php -r 'printf("expose_php=%s\n", ini_get("expose_php"));'
php -r 'printf("display_errors=%s\n", ini_get("display_errors"));'
php -r 'printf("opcache_loaded=%s\n", extension_loaded("Zend OPcache") ? "yes" : "no");'
php -r 'printf("opcache.enable=%s\n", extension_loaded("Zend OPcache") ? ini_get("opcache.enable") : "n/a");'

php -r '
$v = PHP_VERSION;
$fixed = ["8.5" => "8.5.12", "8.4" => "8.4.27", "8.3" => "8.3.36", "8.2" => "8.2.35"];
$branch = implode(".", array_slice(explode(".", $v), 0, 2));
if (isset($fixed[$branch])) {
    printf("branch=%s fixed_for_branch=%s\n", $branch, $fixed[$branch]);
    printf("below_fixed=%s\n", version_compare($v, $fixed[$branch], "<") ? "yes" : "no");
} else {
    printf("branch=%s fixed_for_branch=none_eol\n", $branch);
    printf("below_fixed=unknown_upgrade\n");
}
'
