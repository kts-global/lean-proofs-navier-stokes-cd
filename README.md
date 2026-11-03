# Lean 4 - Proof - Navier–Stokes C/D (KTS Global)

[![verify (cache-assisted)](https://github.com/kts-global/lean-proofs-navier-stokes-cd/actions/workflows/verify.yml/badge.svg)](https://github.com/kts-global/lean-proofs-navier-stokes-cd/actions/workflows/verify.yml) **CI is cache-assisted**: it downloads the Mathlib proof cache and builds this project's modules against it. The from-source claim rests on the builder's offline rebuild (`docs/REBUILD_OFFLINE.md`).

Lean 4 (v4.34.1) proofs of Fefferman's alternatives **(C)** and **(D)** of the Clay Navier-Stokes problem (breakdown of solutions on R^3 and on the 3-torus), of the disjunction **A or B or C or D**, and of logical bridges to the authors' formulation, as formalized in `ClayStatement/Fefferman.lean`.

**The mathematics and the Lean formalization of the blow-up are OpenAI's** (NavierStokesAndEuler, Apache-2.0). The KTS Global statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation are credited to Tim Jacobs, KTS Global, as in the R2R1 release notes (`docs/PROVENANCE.md` quotes the original credit exactly). **No CHAOS-route proof record exists for any result here** (the ECR class is `LIBRARY_SUPPORT`); the four solution assembly files are attributed to CHAOS on the operator's statement alone (below).

## What KTS Global contributed

- **Port** (operator-supplied attribution: Tim Jacobs). Ported OpenAI's NavierStokesAndEuler library (commit `f9e8bc5b38b6`, Lean v4.34.0-rc2 / Mathlib `85e3a25e006c`) to Lean v4.34.1 / Mathlib `d13f23b723b8`: 588 `NavierStokes/*.lean` files unchanged, 21 modified (48 hunks), plus the three build files `lean-toolchain`, `lake-manifest.json` and `lakefile.toml`. Full diff: `docs/PORT_DIFF.patch` (Lean files) and `docs/PORT_DIFF_BUILD.patch`; details: `docs/PORT_SUMMARY.md`.
- **Statement and bridge layer** (Tim Jacobs, KTS Global). The Fefferman-style C and D statements, the bridge theorems, R3 per-alternative packaging, and the community verification tooling, under `ClayStatement/`.
- **Solution assembly files** (operator-supplied attribution: CHAOS). `ClayCSolution`, `ClayDSolution`, `ClayFeffermanSolution` and `ComparatorCompleteSolution`. No route record was found; this attribution rests on the operator's statement.
- **Mathematics and original Lean formalization:** OpenAI (upstream).

## What this is NOT
- It is not a proof of (A) or (B), nor of global regularity.
- It is not independent confirmation that the Lean statements transcribe the official statements (`docs/STATEMENT_CORRESPONDENCE.md`).
- It is not independently reviewed or reproduced: every check was run by the package builder on one Linux node.
- It carries no ECR closing record: the ECR class is `LIBRARY_SUPPORT` (an externally authored, kernel-verified, ECR-checked library declaration; `docs/ECR.md`).

## Rebuild
| Profile | How | Needs |
|---|---|---|
| Online | `./scripts/verify-online.sh` | `elan`, `git`, `python3`, network |
| Offline | the offline release asset, `docs/REBUILD_OFFLINE.md` | Linux x86_64, bash, git, python3, zstd, GNU tar |

Both run the code-aware token scan, build 620 modules, then `CDVerification.lean` and `CDNonVacuity.lean`, and require `RESULT: PASS (14 axiom-policy checks)`. `./scripts/mutation-tests.sh` checks that five wrong or weakened statements and an inserted `sorry` are rejected. Tested platform: Linux x86_64 only.

## Layout
`ClayStatement/`, `NavierStokes/` (the 620 shipped modules), `CDVerification.lean`, `CDNonVacuity.lean`, `results.json`, `docs/`, `evidence/`, `scripts/`, `third_party/`, `RELEASE_MANIFEST.json`.

Start with `STATUS.md`, `docs/PORT_SUMMARY.md`, `docs/STATEMENT_CORRESPONDENCE.md`, `docs/PROVENANCE.md`, `docs/ECR.md` and `docs/KNOWN_LIMITATIONS.md`.

## Licence
Apache License 2.0 (`LICENSE`), unmodified, as in the R2R1 package. Upstream and third-party files keep their own licences (`NOTICE`, `docs/THIRD_PARTY.md`). Earlier history: https://github.com/kts-global/lean-proofs-public (release `r2-r3-v1`), which this repository does not modify.
