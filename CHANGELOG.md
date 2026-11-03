# Changelog

## 1.0.1
- 1.0.1: documentation and provenance only; Lean sources byte-identical to 1.0.0.
- Added the port measurements: `docs/PORT_DIFF.patch` (48 hunks over 21 Lean files), `docs/PORT_DIFF_BUILD.patch`, `docs/PORT_SUMMARY.md`, and `evidence/port_measurement/` (the measurement script and its raw output).
- README: a "What KTS Global contributed" section. Port credit to Tim Jacobs and credit for the four solution assembly files to CHAOS are operator-supplied attributions and are labelled as such; the four files' proof terms were described as the package publisher's in 1.0.0 (`results.json`).
- `results.json`: a `layer` field on each of the 12 roots (`statement_bridge` or `solution_assembly`); root names, declarations and types unchanged. `CITATION.cff`: both contributions listed, version 1.0.1.

## 1.0.0
- First release of this repository: the 620-module closure of the C/D results of the R2R1 package, with a verification module, non-vacuity checks, mutation tests, cache-assisted CI, statement-correspondence and provenance documents, ECR records (LIBRARY_SUPPORT).
- Earlier history: `kts-global/lean-proofs-public`, release `r2-r3-v1` (not modified).
