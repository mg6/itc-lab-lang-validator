#!/bin/bash

set -euo pipefail
test_case="$1"
mkdir -p "tests/${test_case}"
touch "tests/${test_case}/"{input,expected}
