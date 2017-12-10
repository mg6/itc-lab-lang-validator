#!/bin/bash

set -euo pipefail

assert_diff() {
  local root_dir="$1"
  local actual

  actual="$(${root_dir}/lab input 2>&1 || true)"
  diff -wu expected /dev/stdin <<< "$actual" || { cat input; return 1; }
}

run_suite() {
  local root_dir
  local failed=0
  local total=0

  root_dir="$(pwd)"
  shopt -s dotglob

  for path in tests/*; do
    (( ++total ))
    echo "[test case] ${path}"
    pushd "$path" >/dev/null
    assert_diff "$root_dir" || (( ++failed ))
    popd >/dev/null
  done

  local passed=$(( $total - $failed ))
  echo "[summary] total ${total} / failed ${failed} / passed ${passed}"
  [ $failed -eq 0 ]
}

run_suite
