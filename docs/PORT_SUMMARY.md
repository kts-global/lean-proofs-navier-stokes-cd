# Port summary: upstream library to Lean 4.34.1 / Mathlib d13f23b

This file reports **measurements** of the `NavierStokes/` directory of this repository's `main` against the upstream commit it was ported from. It adds no proof and changes no Lean file. Branch `v1.0.1-port-credit`; no tag and no release were created.

## Upstream and target

| | upstream | this repository |
|---|---|---|
| source | `openai/NavierStokesAndEuler` at `f9e8bc5b38b6e212696e8a30e3e91517af887bbd` | `kts-global/lean-proofs-navier-stokes-cd` at `9f3df6786654ffdcfd87e9d324b58f924e60f7c6` |
| `lean-toolchain` | `leanprover/lean4:v4.34.0-rc2` | `leanprover/lean4:v4.34.1` |
| Mathlib pin (`lake-manifest.json`) | `85e3a25e006c` (inputRev `v4.34.0-rc2`) | `d13f23b723b8` (inputRev `d13f23b723b8a846827a245b89c10fc7d3f11612`) |

## What changed in `NavierStokes/*.lean` (counted by comparing bytes)

* upstream `NavierStokes/*.lean` files at that commit: **816**; files in this repository: **613**
* shared paths: **609**: **588 byte-identical** to upstream, **21 modified**
* present here and not upstream: **4** (`NavierStokes/ClayCSolution.lean`, `NavierStokes/ClayDSolution.lean`, `NavierStokes/ClayFeffermanSolution.lean`, `NavierStokes/ComparatorCompleteSolution.lean`); present upstream and not shipped here: **207**
* The figure "24 files modified" that appeared in earlier notes **did not reproduce**; the measured number is **21**.

## The patch (`docs/PORT_DIFF.patch`)

A unified diff (`git diff`, 3 lines of context) of the 21 modified files, upstream (`upstream/...`) to this repository (`package/...`): **48 hunks**. It does not include the 4 added files, which are new, or the toolchain and manifest pins above.

Heuristic classification of what the edits touch, computed by line position (a change is *statement* when it falls before the first `:=` of a declaration, *proof* when after; this is a reading of **where text changed**, not a proof of what was repaired or why): **6 declarations** have a change in their statement region and **40 declarations** have a change only in their proof body; 1 edits fall outside any declaration. The classification counts declarations, not diff hunks, and is not the same number as the hunk count.

## Attribution (operator-supplied; read this before citing)

* **Mathematics and Lean formalization of the blow-up:** OpenAI, `openai/NavierStokesAndEuler` at the commit above (Apache-2.0).
* **The port to Lean 4.34.1 / Mathlib d13f23b:** attributed to **Tim Jacobs, KTS Global**. This attribution is **operator-supplied** (operator ruling R129). It was **not** in the published v1.0.0 release notes, and no machine record names a person for the port patch.
* **`NavierStokes/ClayCSolution.lean`, `ClayDSolution.lean`, `ClayFeffermanSolution.lean`, `ComparatorCompleteSolution.lean`:** attributed to **CHAOS**. This attribution is **operator-supplied** (operator ruling R131). It was not stated in the published v1.0.0 release notes. The builder searched the work-order registry and the ECR records: **no CHAOS leaf-route order, receipt or kernel-check record exists for `ClayCSolution` or `ClayDSolution`**, and the registry rows that mention the other two (`WO-S522-R2-BRIDGE` CLOSED, `WO-S523-NEGCTL-R2F2` CLOSED, `WO-S522-MAP-S521` RECORDED) concern closing and packaging the bridge on 4.34.1 and a negative control, not the authorship of those files. The attribution therefore rests on the operator's statement alone.

## Limits

Measurements of this branch's own repository and the upstream commit only. Nothing here was built or re-verified on the node for this branch; the published v1.0.0 verification is unchanged.
