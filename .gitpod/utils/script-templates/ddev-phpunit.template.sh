#!/usr/bin/env bash

mkdir -p "${GITPOD_REPO_ROOT}/web/sites/simpletest/browser_output"
if [ -f "${GITPOD_REPO_ROOT}/phpunit.xml" ]; then
  phpunit_file=phpunit.xml
else
  phpunit_file=web/core/phpunit.xml.dist
fi
ddev exec_d phpunit -c "/var/www/html/$phpunit_file" "$@"
