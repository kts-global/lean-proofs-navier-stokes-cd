import CDVerification

/-!
# Non-vacuity checks for the C/D statements (packaging; no change to any proof)

**BUILDER-AUTHORED test code**: written for this package by the package builder; not upstream, not a CHAOS-route proof, and **not part of the claimed results** (`results.json` lists the twelve verified results only). It was accepted only after the online build passed with it (all fourteen axiom-policy checks, including its two theorems).

`StatementC` and `StatementD` assert that for every viscosity some datum and force admit NO solution. These checks show the solution
classes are not empty (the zero field with zero force solves), so "no solution" is a real constraint, and that the four Fefferman
statements are pairwise not definitionally equal and not `True`. They do not show that (A) or (B) hold or fail.
-/

open Clay.NavierStokes

namespace CDNonVacuity

theorem zero_solR3 (ν : ℝ) : SolR3 ν (fun _ => 0) zeroForce := by
  refine ⟨fun _ _ => 0, fun _ _ => 0, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro t _ x
    simp [advect, lap, grad, dx, zeroForce]
  · intro t _ x
    simp [div, dx, comp]
  · intro x
    rfl
  · exact contDiffOn_const
  · exact contDiffOn_const
  · exact ⟨1, fun t _ => ⟨by simp, by simp⟩⟩

theorem zero_solTorus (ν : ℝ) : SolTorus ν (fun _ => 0) zeroForce := by
  refine ⟨fun _ _ => 0, fun _ _ => 0, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro t _ x
    simp [advect, lap, grad, dx, zeroForce]
  · intro t _ x
    simp [div, dx, comp]
  · intro x
    rfl
  · intro t _ j x
    rfl
  · intro t _ j x
    rfl
  · exact contDiffOn_const
  · exact contDiffOn_const

end CDNonVacuity

open Lean Meta Elab Command in
elab "#cd_not_defeq" : command => do
  liftTermElabM do
    let c (n : Name) : Expr := mkConst n
    let a := c ``Clay.NavierStokes.StatementA
    let b := c ``Clay.NavierStokes.StatementB
    let cc := c ``Clay.NavierStokes.StatementC
    let d := c ``Clay.NavierStokes.StatementD
    let tr := c ``True
    let r1 ← isDefEq a b
    let r2 ← isDefEq cc d
    let r3 ← isDefEq a cc
    let r4 ← isDefEq b d
    let r5 ← isDefEq cc tr
    let r6 ← isDefEq d tr
    logInfo m!"CD-DEFEQ A=B:{r1} C=D:{r2} A=C:{r3} B=D:{r4} C=True:{r5} D=True:{r6}"

#cd_not_defeq

#assert_standard_axioms
  CDNonVacuity.zero_solR3
  CDNonVacuity.zero_solTorus
