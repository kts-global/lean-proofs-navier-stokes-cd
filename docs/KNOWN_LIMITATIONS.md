# Known limitations

1. Alternatives (A) and (B) are not proved; nothing here bears on them.
2. The Lean statements are not independently confirmed to transcribe the official statements (`STATEMENT_CORRESPONDENCE.md`).
3. Not independently reviewed or reproduced; every run was by the package builder on one Linux x86_64 node.
4. GitHub CI is **cache-assisted**; it does not rebuild Mathlib from source. A hosted runner may not finish the 620-module build within its limit: a timeout is reported as a timeout, not a pass.
5. The ECR class is `LIBRARY_SUPPORT`: the proofs are OpenAI's and the publisher's, not a CHAOS route. From v1.0.1 the four solution assembly files are attributed to CHAOS on the operator's statement alone; no CHAOS route record exists for any result here.
6. The compiler is a prebuilt official binary (offline asset); no compiler-from-source rebuild.
7. Linux x86_64 only.
8. The credit of the KTS Global statement and bridge layer, R3 packaging and verification tooling to Tim Jacobs is as published in the R2R1 release notes and README; no record names a person for the port patch; no file inside the R2R1 package names a person. From v1.0.1 the port is attributed to Tim Jacobs on the operator's statement alone.
9. `CDVerification.lean` and `CDNonVacuity.lean` are builder-authored packaging code (not upstream, not CHAOS-route), and `CDNonVacuity.lean` is not part of the claimed results.
10. The port figures (`docs/PORT_SUMMARY.md`) are measurements by `evidence/port_measurement/measure_port.py`; the statement-versus-proof split is a position heuristic and does not say what was repaired.
