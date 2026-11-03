import ClayStatement
import NavierStokes.ClayFeffermanSolution
import NavierStokes.ComparatorCompleteSolution
import NavierStokes.ClayCSolution
import NavierStokes.ClayDSolution

/-!
# Release verification for the Navier-Stokes C/D package

**BUILDER-AUTHORED packaging code**: written for this package by the package builder; not upstream, not a CHAOS-route proof, and not itself one of the claimed results.

This module is PACKAGING. It does not change, restate or weaken any mathematics. It does two things:

1. `#assert_standard_axioms` fails the build unless every listed declaration depends only on
   `propext`, `Classical.choice` and `Quot.sound` (so an unproved declaration or any additional postulate is rejected).
   `collectAxioms` of a declaration follows its whole dependency closure, so this covers everything each result uses.
2. The `example`s pin the exact statements the package advertises: if a published theorem's type ever
   differed from the stated one, the build would fail.

The mathematics and the Lean formalization of the blow-up are OpenAI's (see docs/PROVENANCE.md). Nothing here proves (A) or (B).
-/

open Lean Elab Command

/-- Fail unless each constant exists and depends only on the three standard axioms. -/
elab "#assert_standard_axioms " ids:ident* : command => do
  let allowed : List Name := [``propext, ``Classical.choice, ``Quot.sound]
  for id in ids do
    let n ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
    let axs ← collectAxioms n
    let bad := axs.filter (fun a => !allowed.contains a)
    if bad.size > 0 then
      throwErrorAt id m!"AXIOM-POLICY FAILED: {n} depends on non-standard axioms {bad}"
    logInfo m!"AXIOM-POLICY OK: {n} depends only on {axs}"

#assert_standard_axioms
  NavierStokes.ClayC.clay_C
  NavierStokes.ClayD.clay_D
  NavierStokes.ClayChallenge.clay_navier_stokes_fefferman
  NavierStokes.ClayChallenge.clay_navier_stokes_fefferman_via_D
  NavierStokes.Comparator.navier_stokes_clay_via_C
  NavierStokes.Comparator.navier_stokes_clay_via_D
  Clay.NavierStokes.Bridge.optionA_iff_statementA
  Clay.NavierStokes.Bridge.optionB_iff_statementB
  Clay.NavierStokes.Bridge.optionC_imp_statementC
  Clay.NavierStokes.Bridge.optionD_imp_statementD
  Clay.NavierStokes.BridgeConverse.statementC_imp_optionC
  Clay.NavierStokes.BridgeConverse.statementD_imp_optionD

example : Clay.NavierStokes.StatementC := NavierStokes.ClayC.clay_C
example : Clay.NavierStokes.StatementD := NavierStokes.ClayD.clay_D
example : Clay.NavierStokes.ClayNavierStokes := NavierStokes.ClayChallenge.clay_navier_stokes_fefferman
example : Clay.NavierStokes.ClayNavierStokes := NavierStokes.ClayChallenge.clay_navier_stokes_fefferman_via_D
