#!/bin/bash

BASELINE=${CI_MERGE_REQUEST_TARGET_BRANCH_SHA:-$CI_MERGE_REQUEST_DIFF_BASE_SHA}

echo "2️⃣ Running test changes for this branch"
# shellcheck disable=SC2143
if git diff "${BASELINE}" --name-only | grep -q -E "Test.php$"; then
  for test in $(git diff "${BASELINE}" --name-only|grep -E "Test.php$"); do
    ddev phpunit -c core "$test" --log-junit="/var/www/html/web/sites/default/files/simpletest/phpunit-$(echo "$test"|sed 's/\//_/g').xml";
  done;
fi
