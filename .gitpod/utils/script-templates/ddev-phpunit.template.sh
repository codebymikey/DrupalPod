#!/usr/bin/env bash
>&2 echo "Notice: running 'phpunit $*' in ddev"

mkdir -p "${GITPOD_REPO_ROOT}/web/sites/simpletest/browser_output"
ddev exec_d phpunit -c /var/www/html/web/core/phpunit.xml.dist "$@"
