#!/usr/bin/env bash
set -euo pipefail

echo "::warning::Test warning message"
echo "Just regular output"

echo "::group::My title"
set -x
ruby --version
bundle --version
{ set +x; } 2>/dev/null
echo "::endgroup::"
