# v1.0.0

Lean 4 (v4.34.1) proofs of Fefferman's alternatives **(C)** and **(D)** of the Clay Navier-Stokes problem (breakdown of solutions on R^3 and on the 3-torus), of the disjunction **A or B or C or D**, and of the logical bridges to the authors' formulation, as formalized in `ClayStatement/Fefferman.lean`: the 620-module import closure of twelve verified results.

- **Credit.** The mathematics and the Lean formalization of the blow-up are OpenAI's (NavierStokesAndEuler, Apache-2.0). The KTS Global statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation are credited to Tim Jacobs, KTS Global, as in the R2R1 release notes; `docs/PROVENANCE.md` quotes the published credit exactly and says what it does and does not establish.
- **What this is not.** It is not a proof of (A) or (B), nor of global regularity. It is not independent confirmation that the Lean statements transcribe the official statements (`docs/STATEMENT_CORRESPONDENCE.md`). It carries no CHAOS-route proof: the ECR class is `LIBRARY_SUPPORT`.
- **Not independently reviewed or reproduced.** Every check was run by the package builder on one Linux x86_64 node. GitHub CI is cache-assisted (it downloads the Mathlib proof cache); the from-source claim rests on the offline rebuild (`docs/REBUILD_OFFLINE.md`). This is a normal release by the operator's decision (2026-11-03) because it packages an existing accepted result with an offline rebuild already demonstrated; the label does not mean an outside reproduction exists.
- Apache-2.0.

Assets: source archive, offline Linux x86_64 asset, release evidence archive, `SHA256SUMS`.
