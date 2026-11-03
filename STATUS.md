# Status

Release v1.0.1 (documentation and provenance only: the Lean sources are byte-identical to v1.0.0). Approved for publication by the operator on 2026-11-03. Not independently reviewed or reproduced: every check was run by the package builder on one Linux x86_64 node, and no outside reproduction has been recorded.

## Established before this tree was frozen (builder-run, one Linux x86_64 node, Lean 4.34.1, Mathlib d13f23b7)
- The R2R1 project, built from source: 9,551 jobs, 0 errors, 8 `sorry` warnings, all in files **outside** this package's closure; manifest unchanged.
- The 12 verified results: returned `DECLARATION_CHECK` jobs accepted by the estate's statement battery (zero unused-hypothesis rows) and recorded in the ECR registry as `LIBRARY_SUPPORT` (`evidence/ecr/`).
- The closure: 620 modules; none contains `sorry`, `axiom`, `opaque`, `unsafe`, `implemented_by`, `extern` or `csimp` in code.

## Results of the closure-only gates (online, offline, archive profiles, mutation tests)
Recorded for v1.0.0 in its release evidence asset (`11_node_gates/` inside it), not in this tree. They were not re-run for v1.0.1, because the Lean sources, toolchain and Mathlib pin are byte-identical to v1.0.0. The v1.0.1 documentation gates (Lean byte-identity, claims, leak scan, archive profiles) are in the v1.0.1 release evidence asset.

## Not established
(A) or (B); that the Lean statements transcribe the official ones; independent reproduction; a CHAOS-route proof.
