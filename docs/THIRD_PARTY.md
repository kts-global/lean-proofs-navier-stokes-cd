# Third-party components

First-party files: Apache License 2.0 (`LICENSE`).

- **NavierStokesAndEuler** (OpenAI): Apache-2.0; upstream README, metadata and licence in `third_party/NavierStokesAndEuler/`. The files of `NavierStokes/` and `ClayStatement/` that originate there keep that licence. `ClayStatement/` (the Fefferman-style statements and the bridges) and the solution modules `NavierStokes/ClayCSolution.lean`, `ClayDSolution.lean`, `ClayFeffermanSolution.lean`, `ComparatorCompleteSolution.lean` were added by KTS Global (the statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation are credited to Tim Jacobs, KTS Global, in the R2R1 release notes; docs/PROVENANCE.md).
- **Formal Conjectures** (Google DeepMind and contributors): `NavierStokes/ComparatorDefinitions.lean` derives from it (header kept).
- **Mathlib**, **Lean 4**, Batteries, Aesop, Qq, ProofWidgets, plausible, LeanSearchClient, import-graph, lean4-cli: fetched at the pinned revisions; not redistributed.
- The CHAOS system, used privately to prepare and check this package, is not distributed or licensed here; nothing here depends on it.
