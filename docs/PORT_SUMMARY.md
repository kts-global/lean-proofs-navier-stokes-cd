# Port summary: upstream library to Lean 4.34.1 / Mathlib d13f23b

Measurements only. This file adds no proof and changes no Lean file. Every figure below is printed by `evidence/port_measurement/measure_port.py` (raw output: `measurement_output.txt`; data: `measurement.json`), run on the v1.0.0 tree against the upstream commit, twice, with identical output.

## Upstream and package

| | upstream | this package |
|---|---|---|
| source | OpenAI `NavierStokesAndEuler`, commit `f9e8bc5b38b6` (2026-09-10), Apache-2.0 | `kts-global/lean-proofs-navier-stokes-cd` |
| Lean | `leanprover/lean4:v4.34.0-rc2` | `leanprover/lean4:v4.34.1` |
| Mathlib | `85e3a25e006c` | `d13f23b723b8` |

## Files (`NavierStokes/*.lean`)

* upstream 816; this package 613
* shared: **609**, of which **588 are byte-identical** to upstream and **21 are modified**
* present here and not upstream: **4** (`ClayCSolution.lean`, `ClayDSolution.lean`, `ClayFeffermanSolution.lean`, `ComparatorCompleteSolution.lean`)
* upstream files not shipped here: **207**

## The patch

* `docs/PORT_DIFF.patch`: the 21 modified Lean files, upstream to this package (`git diff`, 3 lines of context): **48 hunks**.
* Position heuristic: **6 declarations** changed in their statement region and **40 declarations** changed in their proof body only (1 edit lies outside any declaration). This records **where text changed, not what was repaired or why**; it counts declarations, not hunks.
* Build files: three more upstream files differ, `lean-toolchain`, `lake-manifest.json` and `lakefile.toml` (`docs/PORT_DIFF_BUILD.patch`, 3 hunks). The 21 Lean files plus these three make **24 upstream files modified**: the "24 upstream files modified" of the R2R1 records and `docs/PROVENANCE.md`. The R2R1 package's `SOURCE_PATCH/R2_over_upstream.patch` (not redistributed here; read by the builder) modifies exactly those 24 existing upstream files and adds 15 new files.
* `README.md` and `.gitignore` also differ from upstream; they are this package's own files, not part of the port.

## Corrections

* **"24 files modified"** reproduces as 21 Lean files + 3 build files = 24. An earlier draft of this file on this branch said it did not reproduce; that draft counted `NavierStokes/*.lean` only and was wrong.
* **"67 hunks"** did not reproduce. It was a count of line-level edits, a different unit. The hunks of the patch are 48 (Lean files) and 3 (build files).

## Attribution

* **Mathematics and original Lean formalization:** OpenAI (upstream).
* **Port to Lean 4.34.1 / Mathlib d13f23b:** Tim Jacobs, KTS Global. **Operator-supplied attribution** (v1.0.1). It was not in the published v1.0.0 notes; the R2R1 records name KTS Global and no person for the port patch (`docs/PROVENANCE.md`).
* **Statement and bridge layer, R3 per-alternative packaging, community verification tooling:** Tim Jacobs, KTS Global, as published in the R2R1 release notes (quoted exactly in `docs/PROVENANCE.md`).
* **Solution assembly files** (`NavierStokes/ClayCSolution.lean`, `ClayDSolution.lean`, `ClayFeffermanSolution.lean`, `ComparatorCompleteSolution.lean`): CHAOS. **Operator-supplied attribution** (v1.0.1). **No CHAOS route record was found** for any of them: no leaf-route order or receipt shows a CHAOS route producing them. Kernel-checked records do exist for the declarations in these files (the returned `DECLARATION_CHECK` jobs and the ECR records in `evidence/ecr/`), but those records classify them as externally authored, class `LIBRARY_SUPPORT`, with `chaos_route_proof: none recorded`, so they do not support the attribution; package-builder records that name `ClayFeffermanSolution` and `ComparatorCompleteSolution` concern closing and packaging the bridge, not who wrote the files; none names `ClayCSolution` or `ClayDSolution`. The attribution rests on the operator's statement alone. In v1.0.0 these files' proof terms were described as the package publisher's (`results.json`); v1.0.1 records the operator's attribution instead.

## Limits

These are measurements of this repository and one upstream commit. Nothing was rebuilt for this file, and the verification of v1.0.0 is unchanged.
