# v1.0.1

**Documentation and provenance only. The Lean sources, the toolchain (Lean v4.34.1) and the Mathlib pin (`d13f23b723b8`) are byte-identical to v1.0.0.**

- **Port measurements.** Measured against the upstream commit (OpenAI `NavierStokesAndEuler` `f9e8bc5b38b6`, Lean v4.34.0-rc2, Mathlib `85e3a25e006c`): of 609 shared `NavierStokes/*.lean` files, 588 are byte-identical and 21 are modified (48 hunks; 24 upstream files with the three build files); 4 files exist only here; 207 upstream files are not shipped. The patch is `docs/PORT_DIFF.patch`; the details, the heuristic's limits and two corrected figures are in `docs/PORT_SUMMARY.md`; the script and its raw output are in `evidence/port_measurement/`.
- **Attribution.** The README now says what KTS Global contributed. Port credit to Tim Jacobs and credit for the four solution assembly files (`ClayCSolution`, `ClayDSolution`, `ClayFeffermanSolution`, `ComparatorCompleteSolution`) to CHAOS are **operator-supplied attributions**, labelled as such. No CHAOS route record was found for those files, and no CHAOS-route proof is claimed. Neither attribution was in the v1.0.0 notes.
- **Metadata.** `results.json` gains a `layer` field on each root; `CITATION.cff` lists both contributions and the version.
- **Unchanged.** It is not a proof of (A) or (B), not independent confirmation of the statements, and not independently reviewed or reproduced. The v1.0.0 offline from-source rebuild and node gates were not re-run: the Lean sources are byte-identical to v1.0.0.

---

# v1.0.0 (previous release notes, unchanged)

Lean 4 (v4.34.1) proofs of Fefferman's alternatives **(C)** and **(D)** of the Clay Navier-Stokes problem (breakdown of solutions on R^3 and on the 3-torus), of the disjunction **A or B or C or D**, and of the logical bridges to the authors' formulation, as formalized in `ClayStatement/Fefferman.lean`: the 620-module import closure of twelve verified results.

- **Credit.** The mathematics and the Lean formalization of the blow-up are OpenAI's (NavierStokesAndEuler, Apache-2.0). The KTS Global statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation are credited to Tim Jacobs, KTS Global, as in the R2R1 release notes; `docs/PROVENANCE.md` quotes the published credit exactly and says what it does and does not establish.
- **What this is not.** It is not a proof of (A) or (B), nor of global regularity. It is not independent confirmation that the Lean statements transcribe the official statements (`docs/STATEMENT_CORRESPONDENCE.md`). It carries no CHAOS-route proof: the ECR class is `LIBRARY_SUPPORT`.
- **Not independently reviewed or reproduced.** Every check was run by the package builder on one Linux x86_64 node. GitHub CI is cache-assisted (it downloads the Mathlib proof cache); the from-source claim rests on the offline rebuild (`docs/REBUILD_OFFLINE.md`). This is a normal release by the operator's decision (2026-11-03) because it packages an existing accepted result with an offline rebuild already demonstrated; the label does not mean an outside reproduction exists.
- Apache-2.0.

Assets: source archive, offline Linux x86_64 asset, release evidence archive, `SHA256SUMS`.
