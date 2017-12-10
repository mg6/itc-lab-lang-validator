#!/bin/bash

set -euo pipefail

assert_diff() {
  local root_dir="$1"
  local actual

  actual="$(${root_dir}/lab input || true)"
  diff -wu expected /dev/stdin <<< "$actual"
}

run_suite() {
  local root_dir

  root_dir="$(pwd)"
  shopt -s dotglob

  for path in tests/*; do
    echo "[test case] ${path}"
    pushd "$path" >/dev/null
    assert_diff "$root_dir"
    popd >/dev/null
  done
}

run_suite
