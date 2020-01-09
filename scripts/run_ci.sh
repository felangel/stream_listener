#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

cd $1

if grep -q 'sdk: flutter' "./pubspec.yaml"; then
  flutter format --set-exit-if-changed .
  flutter packages get
  flutter analyze --no-congratulate .
  flutter test --coverage --coverage-path coverage/lcov.info
else
  dartfmt --set-exit-if-changed .
  pub get
  dartanalyzer --fatal-infos --fatal-warnings .
  pub run test # have to run this explicitly as test_coverage is NOT showing exceptions correctly
  pub run test_coverage
fi

# Upload coverage results to codecov.io
bash <(curl -s https://codecov.io/bash)

cd -
