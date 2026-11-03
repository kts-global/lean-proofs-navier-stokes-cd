#!/usr/bin/env bash
# Usage: check-results.sh <verification-output-file>
# Fails unless the Lean output of CDVerification.lean and CDNonVacuity.lean shows every axiom-policy check passed.
set -u
f="${1:-}"; [ -n "$f" ] && [ -f "$f" ] || { echo "usage: $0 <verification-output-file>"; exit 2; }
EXPECTED=14
ok=$(grep -c "AXIOM-POLICY OK" "$f" || true); bad=$(grep -c "AXIOM-POLICY FAILED" "$f" || true); err=$(grep -c "error" "$f" || true)
[ "$bad" -eq 0 ] || { echo "RESULT: FAIL ($bad axiom-policy failures)"; exit 1; }
[ "$ok" -eq "$EXPECTED" ] || { echo "RESULT: FAIL (expected $EXPECTED axiom-policy checks, saw $ok)"; exit 1; }
for r in NavierStokes.ClayC.clay_C NavierStokes.ClayD.clay_D NavierStokes.ClayChallenge.clay_navier_stokes_fefferman NavierStokes.ClayChallenge.clay_navier_stokes_fefferman_via_D NavierStokes.Comparator.navier_stokes_clay_via_C NavierStokes.Comparator.navier_stokes_clay_via_D Clay.NavierStokes.Bridge.optionA_iff_statementA Clay.NavierStokes.Bridge.optionB_iff_statementB Clay.NavierStokes.Bridge.optionC_imp_statementC Clay.NavierStokes.Bridge.optionD_imp_statementD Clay.NavierStokes.BridgeConverse.statementC_imp_optionC Clay.NavierStokes.BridgeConverse.statementD_imp_optionD; do
  grep "AXIOM-POLICY OK" "$f" | grep -q "$r " || { echo "RESULT: FAIL (root result $r not checked)"; exit 1; }
done
grep -q "CD-DEFEQ A=B:false C=D:false A=C:false B=D:false C=True:false D=True:false" "$f" || { echo "RESULT: FAIL (the definitional-equality checks did not report the expected values)"; exit 1; }
grep -q "sorryAx" "$f" && { echo "RESULT: FAIL (sorryAx appears)"; exit 1; }
[ "$err" -eq 0 ] || { echo "RESULT: FAIL (lean reported errors)"; exit 1; }
echo "RESULT: PASS ($ok axiom-policy checks)"
