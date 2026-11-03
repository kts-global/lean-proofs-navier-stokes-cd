# Offline rebuild

The offline release asset (`navier-stokes-cd-lean-offline-linux-x86_64-v1.0.0.tar.zst`, checksum in the release notes and `SHA256SUMS`) contains: this project, the nine pinned dependency repositories as git checkouts at the exact manifest revisions, and the official Lean 4.34.1 Linux x86_64 toolchain archive (unmodified; its checksum matches GitHub's published digest for that release asset).
Prerequisites on your machine (not included): Linux x86_64 with a compatible glibc, bash, git, zstd, GNU tar, sha256sum. No network is needed after download.

    ./scripts/verify-offline.sh

It verifies the toolchain checksum, extracts the bundled toolchain, places the bundled dependency repositories under `.lake/packages`, runs the token scan, builds **everything from source (including all of Mathlib; no downloaded caches)**, then elaborates `CDVerification.lean` and `CDNonVacuity.lean` and runs the result check. It prints `RESULT: FAIL (...)` and exits nonzero on any problem, and never falls back to a host Lean installation.

## What the offline rebuild establishes, and how CI differs
The offline rebuild builds **all 9,556 jobs from source (Mathlib included) with no network and no proof cache**, in a network namespace with only loopback. It is the evidence for the from-source claim. GitHub CI (`.github/workflows/verify.yml`) is **cache-assisted**: it downloads the Mathlib proof cache and builds this project against it. CI therefore checks this project's sources and the verification module in a second environment, and does not independently rebuild Mathlib.

## Trust boundary
The Lean compiler and runtime in the bundled toolchain are prebuilt official binaries; the proof sources are rebuilt from source, the compiler is not. `SHA256SUMS` authenticate file bytes only (distribution integrity); they say nothing about mathematical truth.
