#!/usr/bin/env bash
# Offline profile, linux-x86_64 only. Needs: bash, git, python3, zstd, GNU tar, sha256sum, coreutils. No network is used or needed.
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
PLAT="linux-x86_64"
fail() { echo "RESULT: FAIL ($*)"; exit 1; }
[ "$(uname -s)-$(uname -m)" = "Linux-x86_64" ] || fail "this asset supports Linux x86_64 only"
for t in tar git sha256sum zstd python3; do command -v "$t" >/dev/null 2>&1 || fail "missing prerequisite: $t"; done
TCZ="$HERE/toolchain/$PLAT/lean-4.34.1-linux.tar.zst"
[ -f "$TCZ" ] || fail "missing bundled toolchain archive: $TCZ"
for p in mathlib plausible LeanSearchClient importGraph proofwidgets aesop Qq batteries Cli; do [ -e "$HERE/vendor/packages/$p/.git" ] || fail "missing bundled dependency repository: $p"; done
[ -f "$HERE/project/lakefile.toml" ] || fail "missing project directory"
( cd "$HERE" && sha256sum -c --quiet toolchain.sha256 ) || fail "bundled toolchain archive does not match toolchain.sha256"
EXD="$HERE/toolchain/$PLAT/extracted"
if ! ls "$EXD"/*/bin/lake >/dev/null 2>&1; then mkdir -p "$EXD"; zstd -dc "$TCZ" | tar --no-same-owner -xf - -C "$EXD" || fail "toolchain extraction"; fi
TC="$(ls -d "$EXD"/*/ | head -1)"; TC="${TC%/}"
export PATH="$TC/bin:/usr/bin:/bin"; unset ELAN_HOME LEAN_PATH LEAN_SYSROOT
have="$(lean --version 2>&1 | sed -n 's/.*version \([0-9][0-9.]*\).*/\1/p')"
[ "$have" = "4.34.1" ] || fail "bundled toolchain reports Lean '$have', need 4.34.1"
mkdir -p "$HERE/project/.lake/packages"
for p in "$HERE"/vendor/packages/*; do n="$(basename "$p")"; [ -e "$HERE/project/.lake/packages/$n" ] || cp -a "$p" "$HERE/project/.lake/packages/$n" || fail "copying dependency $n"; done
cd "$HERE/project"
( cd "$HERE/project" && ./scripts/scan-tokens.sh ) || fail "token scan found a forbidden marker in the Lean sources"
echo "Building everything from source (no caches, no network). Log: $HERE/offline-build.log"
start=$(date +%s)
lake build ClayStatement NavierStokes CDVerified > "$HERE/offline-build.log" 2>&1; rc=$?
echo "build seconds: $(( $(date +%s) - start ))"; tail -n 3 "$HERE/offline-build.log"
[ "$rc" -eq 0 ] || fail "lake build exited $rc (see offline-build.log)"
( lake env lean CDVerification.lean && lake env lean CDNonVacuity.lean ) > "$HERE/verification.out" 2>&1; rc=$?
[ "$rc" -eq 0 ] || { tail -20 "$HERE/verification.out"; fail "verification exited $rc"; }
./scripts/check-results.sh "$HERE/verification.out"
