#!/usr/bin/env bash
# Mutation tests. M0 (the unmutated statement) must elaborate. M1 (the bridge used without its premise, i.e. without the authors' breakdown theorem),
# M2 (alternative C's proof offered for alternative D), M3 (an unproved theorem placed in the axiom-assert list) and M4 (alternative C's proof
# offered for (A)) must FAIL. Needs a built package (lake build ClayStatement NavierStokes CDVerified).
set -u
cd "$(dirname "$0")/.."
pass=0; total=0
run() { # name expect(0|1)
  total=$((total+1)); f="_MutationProbe.lean"; cp "scripts/mutations/$1.lean.txt" "$f"
  out="$(lake env lean "$f" 2>&1)"; rc=$?; rm -f "$f"
  if [ "$2" = "0" ]; then if [ "$rc" -eq 0 ]; then pass=$((pass+1)); echo "ok   $1 elaborates (expected)"; else echo "FAIL $1 should elaborate"; echo "$out" | head -5; fi
  else if [ "$rc" -ne 0 ]; then pass=$((pass+1)); echo "ok   $1 rejected (expected): $(echo "$out" | grep -m1 -E 'error|AXIOM-POLICY FAILED' | cut -c1-110)"; else echo "FAIL $1 was accepted but must be rejected"; fi; fi
}
run M0_control_pass 0; run M1_drop_premise 1; run M2_wrong_alternative_D 1; run M3_unproved_in_assert_list 1; run M4_claim_alternative_A 1
if [ "$pass" -eq "$total" ]; then echo "RESULT: PASS ($pass/$total mutation checks)"; else echo "RESULT: FAIL ($pass/$total)"; exit 1; fi
