#!/usr/bin/env bash
# Code-aware token scan (needs python3, standard library only).
set -u
cd "$(dirname "$0")/.."
command -v python3 >/dev/null 2>&1 || { echo "RESULT: FAIL (python3 not found)"; exit 2; }
python3 scripts/scan_tokens.py
