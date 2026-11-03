#!/usr/bin/env bash
# Online profile: needs elan (Lean 4.34.1 is installed from lean-toolchain), git, python3 and network access to GitHub.
set -uo pipefail
cd "$(dirname "$0")/.."
command -v lake >/dev/null 2>&1 || { echo "lake not found: install elan first (https://github.com/leanprover/elan)"; exit 2; }
want="$(sed 's/.*v//' lean-toolchain)"; have="$(lean --version | sed -n 's/.*version \([0-9.]*\).*/\1/p')"
[ "$have" = "$want" ] || { echo "wrong Lean version: have $have, need $want"; exit 2; }
./scripts/scan-tokens.sh || exit 1
[ -n "${SKIP_CACHE:-}" ] || lake exe cache get || { echo "cache download failed (set SKIP_CACHE=1 to build Mathlib from source)"; exit 3; }
lake build ClayStatement NavierStokes CDVerified 2>&1 | tee build.log; rc=${PIPESTATUS[0]}
[ "$rc" -eq 0 ] || { echo "RESULT: FAIL (lake build exited $rc; see build.log)"; exit 1; }
if grep -q "declaration uses .\{0,3\}sorry" build.log; then echo "RESULT: FAIL (the build reports declarations that use sorry; see build.log)"; exit 1; fi
( lake env lean CDVerification.lean && lake env lean CDNonVacuity.lean ) > verification.out 2>&1; rc=$?
[ "$rc" -eq 0 ] || { echo "RESULT: FAIL (verification exited $rc; see verification.out)"; tail -20 verification.out; exit 1; }
./scripts/check-results.sh verification.out
